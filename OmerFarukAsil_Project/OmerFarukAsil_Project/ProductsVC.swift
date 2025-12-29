//
//  ProductsVC.swift
//  OmerFarukAsil_Project
//
//  Created by Ömer Faruk Asil on 24.12.2025.
//

import UIKit
import Kingfisher
import CoreData

class ProductsVC: UIViewController, ProductDetailDelegate {

    @IBOutlet weak var productTableView: UITableView!
    
    var selectedCategory: Category?
    
    var selectedProduct: Product?
    
    var mCart: [Cart] = []
    
    var mFavorite: [Favorite] = []
    
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
        
        fetchCartData()
        
        fetchFavoriteData()

        productTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "showProductDetail",
           let destination = segue.destination as? ProductDetailVC {

            destination.product = selectedProduct
            destination.delegate = self
        }
    }
    
    func addFavoriteProduct(_ product: Product){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let newFavoriteItem = Favorite(context: context)
        newFavoriteItem.name = product.name
        newFavoriteItem.brand = product.brand
        newFavoriteItem.currency = product.currency
        newFavoriteItem.desc = product.description
        newFavoriteItem.id = Int64(product.id)
        newFavoriteItem.image = product.images.first ?? ""
        newFavoriteItem.price = product.price
        
        do {
            try context.save()
        } catch {
            print("Save error: \(error)")
        }
        
        fetchFavoriteData()
    }
    
    func addCartProduct(_ product: Product) {

        let context = (UIApplication.shared.delegate as! AppDelegate)
            .persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<Cart> = Cart.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", product.id)

        do {
            let results = try context.fetch(fetchRequest)

            if !results.isEmpty {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.warning)
                return
            }

            let newCartItem = Cart(context: context)
            newCartItem.name = product.name
            newCartItem.brand = product.brand
            newCartItem.currency = product.currency
            newCartItem.desc = product.description
            newCartItem.id = Int64(product.id)
            newCartItem.image = product.images.first ?? ""
            newCartItem.price = product.price

            try context.save()
            fetchCartData()

            UIImpactFeedbackGenerator(style: .light).impactOccurred()

        } catch {
            print("Add cart error:", error)
        }
    }
    
    func fetchCartData(){
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        
        let sortDescriptor1 = NSSortDescriptor(key: "name", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "brand", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
        
        do {
            let results = try context.fetch(fetchRequest)
            mCart = results as! [Cart]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
    
    func fetchFavoriteData(){
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        
        let sortDescriptor1 = NSSortDescriptor(key: "name", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "brand", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
        
        do {
            let results = try context.fetch(fetchRequest)
            mFavorite = results as! [Favorite]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
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

