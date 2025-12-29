//
//  ProductDetailVC.swift
//  OmerFarukAsil_Project
//
//  Created by Ömer Faruk Asil on 24.12.2025.
//

import UIKit
import Kingfisher

protocol ProductDetailDelegate: AnyObject {
    func addFavoriteProduct(_ product: Product)
    func addCartProduct(_ product: Product)
}

class ProductDetailVC: UIViewController {
    
    var product: Product?

    @IBOutlet weak var nameOfPoduct: UILabel!
    
    @IBOutlet weak var imageOfProduct: UIImageView!
    
    @IBOutlet weak var priceOfProduct: UILabel!
    
    @IBOutlet weak var descriptionOfProduct: UITextView!
    
    weak var delegate: ProductDetailDelegate?

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
            priceOfProduct.text = String(product.price) + " TL"
            descriptionOfProduct.text = product.description
            
                    // diğer UI ayarları burada
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func pressedFavoriteButton(_ sender: Any){
        navigationController?.popViewController(animated: true)
        delegate?.addFavoriteProduct(product!)
    }
    
    @IBAction func pressedCartButton(_ sender: Any){
        navigationController?.popViewController(animated: true)
        delegate?.addCartProduct(product!)
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
