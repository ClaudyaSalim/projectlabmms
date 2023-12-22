//
//  CartViewController.swift
//  projectLab
//
//  Created by prk on 22/12/23.
//

import UIKit
import CoreData

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var activeUser:Person?
    var db = Database()
    var contxt: NSManagedObjectContext?
    
    var cartList = [CartItem]()
    var price = 0
    
    
    @IBOutlet weak var totalPayment: UILabel!
    
    @IBOutlet weak var cartTable: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        contxt = appDelegate.persistentContainer.viewContext
        
        let email = UserDefaults.standard.string(forKey: "userEmail")
        activeUser = db.getUser(contxt: contxt!, email: email!)
        print(activeUser!.name)
        
        cartTable.dataSource = self
        cartTable.delegate = self
        
        cartList = db.getItemsByUser(contxt: contxt!, userEmail: email!)
        
        for cart in cartList {
            price += cart.price!
        }
        
        totalPayment.text = "Rp\(price)"
        
    }
    
    
    @IBAction func confirmLabel(_ sender: Any) {
        if(price != 0){
            db.deleteCart(contxt: contxt!, userEmail: activeUser!.email!)
            if let confirmPay = storyboard?.instantiateViewController(withIdentifier: "confirmViewController"){
                let confirmPageView = confirmPay as! ConfirmViewController
                
                navigationController?.setViewControllers([confirmPageView], animated: true)
            }
        }
        else {
            showAlert()
        }
        
    }
    
    //  delete
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                db.deleteCartByUserProduct(contxt: contxt!, productName: cartList[indexPath.row].productName!, userEmail: activeUser!.email!)
                cartList.remove(at: indexPath.row)
                cartTable.reloadData()
            }
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell") as! CartTableViewCell
        let productName = cartList[indexPath.row].productName
        let product = db.getProduct(contxt: contxt!, name: productName!)
        
        cell.productName.text = product.name
        cell.productCategory.text = product.category
        cell.productPrice.text = "Rp\(cartList[indexPath.row].price!)"
        cell.qty.text = "\(cartList[indexPath.row].qty!)"
        if let imagePath = product.img,
            let image = UIImage(contentsOfFile: imagePath) {
               cell.productImage.image = image
           } else {
               cell.productImage.image = UIImage(named: "defaultImage")
           }
                
        return cell
    }
    
    func showAlert(){
        
        let alert = UIAlertController(title: "Your Cart is Empty!", message: "At least 1 item should be in the cart!", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
}
