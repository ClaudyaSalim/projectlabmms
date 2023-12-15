//
//  AddItemAdminViewController.swift
//  projectLab
//
//  Created by prk on 15/12/23.
//

import UIKit
import CoreData

class AddItemAdminViewController: UIViewController {
        
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var descField: UITextField!
    
    var contxt: NSManagedObjectContext!
    var db=Database()

    override func viewDidLoad() {
        super.viewDidLoad()

        // setup core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        contxt = appDelegate.persistentContainer.viewContext
    }
    

    @IBAction func onConfirmClicked(_ sender: Any) {
        
        var newItem:Item?
        let name = nameField.text!
        let category = categoryField.text!
        let price = Int(priceField.text!)
        let desc = descField.text!
        
        if(name=="" || category=="" || price==nil || desc==""){
            showAlert(msg: "You must fill all fields!")
            return
        }
        
        newItem = Item(name: name, category: category, price: price, desc: desc)
        
        db.insertProduct(contxt: contxt, product: newItem!)
        
    }
    
    func showAlert(msg:String){
        
        // define alert
        let alert = UIAlertController(title: "Add Product Failed", message: msg, preferredStyle: .alert)
        
        // define action
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        
        // add action to alert
        alert.addAction(okAction)
        
        // show alert
        present(alert, animated: true)
    }

}
