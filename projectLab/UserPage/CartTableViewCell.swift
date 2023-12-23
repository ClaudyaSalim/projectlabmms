//
//  CartTableViewCell.swift
//  projectLab
//
//  Created by prk on 22/12/23.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var qty: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
