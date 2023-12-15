//
//  ProductTableViewCell.swift
//  projectLab
//
//  Created by prk on 15/12/23.
//

import UIKit
import CoreData

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    var db = Database()
    var contxt: NSManagedObjectContext!
    var item:Item?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        contxt = appDelegate.persistentContainer.viewContext
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        // masih coba"
//        let name = productName.text
//        item = db.getProduct(contxt: contxt, name: name!)
        
        
    }

}
