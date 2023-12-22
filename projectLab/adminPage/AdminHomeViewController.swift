//
//  AdminHomeViewController.swift
//  projectLab
//
//  Created by prk on 13/12/23.
//

import UIKit
import CoreData

class AdminHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var greetingLabel: UILabel!
    var activeUser:Person?
    var db = Database()
    var contxt: NSManagedObjectContext!
    
    var productList = [Item]()
    var item:Item?
    
    
    @IBOutlet weak var productTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        contxt = appDelegate.persistentContainer.viewContext

        // Do any additional setup after loading the view.
        let email = UserDefaults.standard.string(forKey: "userEmail")
        activeUser = db.getUser(contxt: contxt, email: email!)
        print(activeUser!.name)
        greetingLabel.text = "Hello, Admin \(activeUser!.name!)!"
        
        productTable.dataSource = self
        productTable.delegate = self
        
        initData()
    }
    
    func initData(){
        productList = db.getProducts(contxt: contxt)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productList.count
    }
    
    
//  delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            db.deleteProduct(contxt: contxt, name: productList[indexPath.row].name!)
            productList.remove(at: indexPath.row)
            
            productTable.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        item = productList[indexPath.row]
        
        if let nextview = storyboard?.instantiateViewController(withIdentifier: "updateItemAdmin") {
            let updateView = nextview as! UpdateItemAdminViewController

            updateView.item = item

            navigationController?.pushViewController(updateView, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell") as! AdminProductTableViewCell
        cell.nameproduct.text = productList[indexPath.row].name!
        cell.categoryproduct.text = productList[indexPath.row].category!
        cell.priceproduct.text = "Rp\(productList[indexPath.row].price!)"
        
        if let imagePath = productList[indexPath.row].img, let image = UIImage(contentsOfFile: imagePath) {
               cell.imageproduct.image = image
           } else {
               cell.imageproduct.image = UIImage(named: "defaultImage")
           }
                
        return cell
    }
    
    
    @IBAction func onAddItemClick(_ sender: Any) {
        if let nextView = self.storyboard?.instantiateViewController(withIdentifier: "addAdminItem") {
                let addAdminView = nextView as! AddItemAdminViewController
                self.navigationController?.setViewControllers([addAdminView], animated: true)
        }
    }
    
    
    
    @IBAction func onClickLogout(_ sender: Any) {
        
        let AlertLogOut = UIAlertController(title: "Logout", message: "Are you sure want to logout?", preferredStyle: .alert)
            
        let OkAction = UIAlertAction(title: "Logout", style: .destructive) { _ in
                // Perform logout actions
                UserDefaults.standard.removeObject(forKey: "userEmail")
                
            if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginPage") {
                    let loginView = loginVC as! ViewController
                    self.navigationController?.setViewControllers([loginView], animated: true)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        AlertLogOut.addAction(cancelAction)
        AlertLogOut.addAction(OkAction)
            
        present(AlertLogOut, animated: true, completion: nil)
    }
    
    

}
