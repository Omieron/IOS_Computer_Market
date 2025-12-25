//
//  ProductsTableViewCell.swift
//  OmerFarukAsil_Project
//
//  Created by Ömer Faruk Asil on 25.12.2025.
//

import UIKit

class ProductsTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var priceProduct: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
