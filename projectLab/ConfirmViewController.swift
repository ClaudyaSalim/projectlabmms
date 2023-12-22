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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
