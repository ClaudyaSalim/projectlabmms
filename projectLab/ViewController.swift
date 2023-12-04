//
//  ViewController.swift
//  projectLab
//
//  Created by prk on 18/11/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emailFieldLogin: UITextField!
    
    @IBOutlet weak var passFieldLogin: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLoginClick(_ sender: Any) {
        
        let emailTxtRegist = emailFieldLogin.text
        let passTxtRegist = passFieldLogin.text
        
        if let nextView = storyboard?.instantiateViewController(withIdentifier: "MainPage") {
                let mainPageView = nextView as! TabViewController
            
                // passing data

                navigationController?.setViewControllers([mainPageView], animated: true)
        }
    }
    
    @IBAction func onRegisClick(_ sender: Any) {
        if let nextView = storyboard?.instantiateViewController(withIdentifier: "RegisterPage") {
                let regisPageView = nextView as! RegisViewController

                navigationController?.setViewControllers([regisPageView], animated: true)
        }
    }
    
    
    //Keyboard Off
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

