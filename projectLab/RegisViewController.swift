//
//  RegisViewController.swift
//  projectLab
//
//  Created by prk on 02/12/23.
//

import UIKit
import CoreData

class RegisViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var confirmPassField: UITextField!
    
    var userArr = [Person]()
    var contxt: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // setup core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        contxt = appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func onRegisClick(_ sender: Any) {
        
        var newPerson: Person?
        
        // ambil dari text field
        let name = nameField.text!
        let email = emailField.text!
        let pass = passField.text!
        let confirmPass = confirmPassField.text!
        
        // validasi
        if(name=="" || email=="" || pass=="" || confirmPass==""){
            showAlert(msg: "All fields must be filled")
            return
        }
        else if(!(pass==confirmPass)){
            showAlert(msg: "Password and Confirm Password should be the same")
            return
        }
        
        print(name, email, pass)
        
        newPerson = Person(name: name, email: email, pass: pass)
        // tambahin ke core data
//        newPerson!.name = name
//        newPerson!.email = email
//        newPerson!.pass = pass
        
        createData(person:newPerson!)
        
        
        if let nextView = storyboard?.instantiateViewController(withIdentifier: "MainPage") {
                let mainPageView = nextView as! TabViewController

                // passing data

                navigationController?.setViewControllers([mainPageView], animated: true)
        }
    }
    

    @IBAction func onLoginClick(_ sender: Any) {
        if let nextView = storyboard?.instantiateViewController(withIdentifier: "LoginPage") {
                let loginPageView = nextView as! ViewController

                navigationController?.setViewControllers([loginPageView], animated: true)
        }
    }
    
    
    func createData(person:Person) {
        
        let entity = NSEntityDescription.entity(forEntityName: "User", in: contxt)
        
        let newPerson = NSManagedObject(entity: entity!, insertInto: contxt)
        newPerson.setValue(person.name, forKey: "name")
        newPerson.setValue(person.email, forKey: "email")
        newPerson.setValue(person.pass, forKey: "password")
        
        do {
            try contxt.save()
            loadData()
        } catch {
            print("Entity creation failed")
        }
        
    }
    
    
    func loadData() {
        userArr.removeAll()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        do {
            let result = try contxt.fetch(request) as! [NSManagedObject]
            
            for data in result {
                userArr.append(
                    Person(name: data.value(forKey: "name") as! String, email: data.value(forKey: "email") as! String, pass: data.value(forKey: "password") as! String))
            }
            
            for i in userArr {
                print(i)
            }
            
//            contactsTableView.reloadData()
        } catch {
            print("Data loading failure")
        }
    }
    
    
    func showAlert(msg:String){
        
        // define alert
        let alert = UIAlertController(title: "Login Failed", message: msg, preferredStyle: .alert)
        
        // define action
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        
        // add action to alert
        alert.addAction(okAction)
        
        // show alert
        present(alert, animated: true)
    }
    
    
    //Keyboard Off
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
