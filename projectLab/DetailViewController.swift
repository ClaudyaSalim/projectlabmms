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
        }
        
    }
    
    @IBAction func onAddClick(_ sender: Any) {
        let qty = Int(qtyField.text!)
        // tambahin validasi di qty biar ga nil
        let cartItem = CartItem(userEmail: email!, productName: item!.name!, qty: qty, price: item!.price!*qty!)
        db.insertToCart(contxt: contxt, cartItem: cartItem)
        // core data nya harus ada validasi kalo ada barang yg sama ditambahin ke cart nanti jatuhnya update quantity
    }
    

}
