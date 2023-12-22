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

}
