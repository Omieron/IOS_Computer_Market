//
//  ProductDetailVC.swift
//  OmerFarukAsil_Project
//
//  Created by Ömer Faruk Asil on 24.12.2025.
//

import UIKit
import Kingfisher

class ProductDetailVC: UIViewController {
    
    var product: Product?

    @IBOutlet weak var nameOfPoduct: UILabel!
    
    @IBOutlet weak var imageOfProduct: UIImageView!
    
    @IBOutlet weak var priceOfProduct: UILabel!
    
    @IBOutlet weak var descriptionOfProduct: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let product = product {
            title = product.brand
            nameOfPoduct.text = product.name
            if let firstImage = product.images.first, let url = URL(string: firstImage) {
                imageOfProduct.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
            } else {
                imageOfProduct.image = UIImage(named: "placeholder")
            }
            priceOfProduct.text = String(product.price)
            descriptionOfProduct.text = product.description
            
                    // diğer UI ayarları burada
        }

        // Do any additional setup after loading the view.
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
