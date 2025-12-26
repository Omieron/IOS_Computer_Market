//
//  ProductsVC.swift
//  OmerFarukAsil_Project
//
//  Created by Ömer Faruk Asil on 24.12.2025.
//

import UIKit
import Kingfisher

class ProductsVC: UIViewController {

    @IBOutlet weak var productTableView: UITableView!
    
    var selectedCategory: Category?
    
    var selectedProduct: Product?
    
    let jsonDataSource = DataSoruce()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let category = selectedCategory else { return }
        title = category.name
        
        //let categoriesToShow: [Category]
        
        /*if category.children.isEmpty {
            categoriesToShow = [category]
        } else {
            categoriesToShow = category.children.flatMap { $0.children }
        }
        */
        jsonDataSource.populateFromJSON()

        productTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "showProductDetail",
           let destination = segue.destination as? ProductDetailVC {

            destination.product = selectedProduct
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

extension ProductsVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return jsonDataSource.numberOfProducts()
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductsCell", for: indexPath) as! ProductsTableViewCell

        let product = jsonDataSource.productAt(index: indexPath.row)

        cell.productName.text = product.name
        cell.priceProduct.text = "\(product.price) \(product.currency)"

        if let firstImage = product.images.first, let url = URL(string: firstImage) {
            cell.productImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        } else {
            cell.productImage.image = UIImage(named: "placeholder")
        }

        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        selectedProduct = jsonDataSource.productAt(index: indexPath.row)

        performSegue(withIdentifier: "showProductDetail", sender: self)
    }

}

