//
//  ViewController.swift
//  projectLab
//
//  Created by prk on 18/11/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLoginClick(_ sender: Any) {
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
    
    
}

