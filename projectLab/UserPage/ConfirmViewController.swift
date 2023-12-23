//
//  ConfirmViewController.swift
//  projectLab
//
//  Created by prk on 22/12/23.
//

import UIKit

class ConfirmViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func cartList(_ sender: Any) {

        if let mainPage = storyboard?.instantiateViewController(withIdentifier: "MainPage"){
            let tabPageView = mainPage as! TabViewController
            
            navigationController?.setViewControllers([tabPageView], animated: true)
            
        }
        
    }

}
