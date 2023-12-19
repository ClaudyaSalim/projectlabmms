//
//  AdminProductTableViewCell.swift
//  projectLab
//
//  Created by prk on 12/19/23.
//

import UIKit

class AdminProductTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var imageproduct: UIImageView!
    
    @IBOutlet weak var nameproduct: UILabel!
    
    @IBOutlet weak var categoryproduct: UILabel!
    
    
    @IBOutlet weak var priceproduct: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
