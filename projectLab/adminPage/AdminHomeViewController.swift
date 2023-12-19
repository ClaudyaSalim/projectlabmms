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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
