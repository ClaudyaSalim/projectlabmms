//
//  HomeViewController.swift
//  projectLab
//
//  Created by prk on 06/12/23.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {

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
        greetingLabel.text = "Hello \(activeUser!.name!)!"
    }
    

}
