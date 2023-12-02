//
//  RegisViewController.swift
//  projectLab
//
//  Created by prk on 02/12/23.
//

import UIKit

class RegisViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onLoginClick(_ sender: Any) {
        if let nextView = storyboard?.instantiateViewController(withIdentifier: "LoginPage") {
                let loginPageView = nextView as! ViewController

                navigationController?.setViewControllers([loginPageView], animated: true)
        }
    }
    

}
