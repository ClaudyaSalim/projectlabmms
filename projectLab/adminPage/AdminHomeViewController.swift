//
//  AdminHomeViewController.swift
//  projectLab
//
//  Created by prk on 13/12/23.
//

import UIKit
import CoreData

class AdminHomeViewController: UIViewController {

    @IBOutlet weak var greetingLabel: UILabel!
    var activeUser:Person?
    var db = Database()
    var contxt: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // setup core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        contxt = appDelegate.persistentContainer.viewContext

        // Do any additional setup after loading the view.
        let email = UserDefaults.standard.string(forKey: "userEmail")
        activeUser = db.getUser(contxt: contxt, email: email!)
        print(activeUser!.name)
        greetingLabel.text = "Hello, Admin \(activeUser!.name!)!"
    }
    
    
    @IBAction func onClickLogout(_ sender: Any) {
        if let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginPage") {
            let loginView = loginVC as! ViewController
            navigationController?.setViewControllers([loginView], animated: true)
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
