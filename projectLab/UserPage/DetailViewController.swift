//
//  DetailViewController.swift
//  projectLab
//
//  Created by prk on 16/12/23.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    var item:Item?
    var email:String?
    var db = Database()
    var contxt: NSManagedObjectContext!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var qtyField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        contxt = appDelegate.persistentContainer.viewContext
        
        email = UserDefaults.standard.string(forKey: "userEmail")
        
        if(item != nil){
            nameLabel.text = item!.name!
            categoryLabel.text = item!.category!
            priceLabel.text = "Rp\(item!.price!)"
            descLabel.text = item!.desc!
            
            print(item?.img)
            if let imagePath = item!.img {
                let image = UIImage(contentsOfFile: imagePath)
                imageView.image = image
            }else{
                imageView.image = UIImage(named: "defaultImage")
            }
            
        }
        
    }
    
    
    
    @IBAction func onAddClick(_ sender: Any) {
        guard let qtyTxt = qtyField.text, let qty = Int(qtyTxt) else{
            
            let alerts = UIAlertController(title: "Error", message: "Quantity must be a valid number", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alerts.addAction(okAction)
            self.present(alerts, animated: true)
            return
        }
        // tambahin validasi di quantity biar ga nil dan nol
        
        if qty <= 0 {
            let alerts = UIAlertController(title: "Error", message: "Quantity must be more than 0", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alerts.addAction(okAction)
            self.present(alerts, animated: true)
            return
        }
        
        
        let cartItem = CartItem(userEmail: email!, productName: item!.name!, qty: qty, price: item!.price! * qty)
        let itemFound = db.getItemByUserAndProduct(contxt: contxt, name: cartItem.productName!, userEmail: email!)
        print("This item is in cart", itemFound)
        
        // kalo ada barang yg sama ditambahin ke cart nanti jatuhnya update quantity
        
        if (itemFound.productName != nil){
            // update database
            print("update")
            db.updateQty(contxt: contxt, userEmail: email!, name: item!.name!, newQty: qty, newPrice: qty * item!.price!)
            showAlert(title: "Item Updated", msg: "Item quantity in cart has successfully updated!")
        }
        else {
            // insert to cart
            print("insert")
            db.insertToCart(contxt: contxt, cartItem: cartItem)
            showAlert(title: "Item Added", msg: "Item successfully added into the cart!")
        }
        
        
        
    }
    

    func showAlert(title:String, msg:String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default){ _ in
                            
            if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "MainPage") {
                    let loginView = loginVC as! TabViewController
                    self.navigationController?.setViewControllers([loginView], animated: true)
            }
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}
