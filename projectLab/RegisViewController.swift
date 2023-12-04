//
//  RegisViewController.swift
//  projectLab
//
//  Created by prk on 02/12/23.
//

import UIKit

class RegisViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var confirmPassField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onRegisClick(_ sender: Any) {
        
        // ambil dari text field
        let name = nameField.text
        let email = emailField.text
        let pass = passField.text
        let confirmPass = confirmPassField.text
        
        // validasi
        if(name=="" || email=="" || pass=="" || confirmPass==""){
            showAlert(msg: "All fields must be filled")
        }
        else if(!(pass==confirmPass)){
            showAlert(msg: "Password and Confirm Password should be the same")
        }
        
        
        
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
