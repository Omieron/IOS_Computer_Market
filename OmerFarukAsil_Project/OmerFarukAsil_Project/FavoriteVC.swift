//
//  FavoriteVC.swift
//  OmerFarukAsil_Project
//
//  Created by Ömer Faruk Asil on 29.12.2025.
//

import UIKit
import Kingfisher
import CoreData
import AudioToolbox

class FavoriteVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var favoriteTableView: UITableView!
    
    @IBOutlet weak var favIsEmptyImage: UIImageView!
    
    @IBOutlet weak var favIsEmptyLabel: UILabel!
    
    @IBOutlet weak var favIsEmptyDesc: UILabel!
    
    @IBOutlet weak var favIsEmptyBtn: UIButton!
    
    var mFavorite: [Favorite] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mFavorite.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Recommended way
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavCell", for: indexPath) as! CartCustomTableViewCell
        
        // Get the Student for this index
        let cart = mFavorite[indexPath.row]
        
        
        if let pImage = cart.image, let url = URL(string: pImage) {
            cell.productImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        } else {
            cell.productImage.image = UIImage(named: "placeholder")
        }
        
        cell.productNameLabel.text = cart.name
        cell.productPriceLabel.text = "\(cart.price) TL"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive,title: "Delete") { _, _, completion in
            
            self.deleteCartItem(at: indexPath)
            completion(true)
            
            AudioServicesPlaySystemSound(1157)
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
            
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let addToCartAction = UIContextualAction(style: .normal, title: "Add") { _, _, completion in

            self.addFavoriteItemToCart(at: indexPath)
            completion(true)

            AudioServicesPlaySystemSound(1104)
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }

        addToCartAction.backgroundColor = .systemGreen
        addToCartAction.image = UIImage(systemName: "cart.badge.plus")

        return UISwipeActionsConfiguration(actions: [addToCartAction])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        favoriteTableView.reloadData()
    }
    
    @IBAction func browseProductsTapped(_ sender: UIButton) {
        tabBarController?.selectedIndex = 1
    }
    
    func fetchData(){
        
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
        
        CheckIsDataAvailable()
        
    }
    
    func addFavoriteItemToCart(at indexPath: IndexPath) {

        let context = (UIApplication.shared.delegate as! AppDelegate)
            .persistentContainer.viewContext

        let favoriteItem = mFavorite[indexPath.row]

        let fetchRequest: NSFetchRequest<Cart> = Cart.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", favoriteItem.id)

        do {
            let results = try context.fetch(fetchRequest)

            if !results.isEmpty {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.warning)
                showAlertMessage(message : "The item is already placed at cart.", title: "Warning")
                return
            }

            let newCartItem = Cart(context: context)
            newCartItem.name = favoriteItem.name
            newCartItem.brand = favoriteItem.brand
            newCartItem.currency = favoriteItem.currency
            newCartItem.desc = favoriteItem.desc
            newCartItem.id = favoriteItem.id
            newCartItem.image = favoriteItem.image
            newCartItem.price = favoriteItem.price

            try context.save()

            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            
            showAlertMessage(message : "The item has been placed successfully to cart.", title: "Added To Cart")

        } catch {
            print("Add to cart error:", error)
        }
    }
    
    func deleteCartItem(at indexPath: IndexPath) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate)
            .persistentContainer.viewContext

        let itemToDelete = mFavorite[indexPath.row]

        context.delete(itemToDelete)

        do {
            try context.save()
            mFavorite.remove(at: indexPath.row)
            favoriteTableView.deleteRows(at: [indexPath], with: .automatic)
            CheckIsDataAvailable()
        } catch {
            print("Delete error:", error)
        }
    }
    
    func CheckIsDataAvailable(){
        if mFavorite.isEmpty == true{
            favIsEmptyLabel.isHidden = false
            favIsEmptyImage.isHidden = false
            favIsEmptyDesc.isHidden = false
            favIsEmptyBtn.isHidden = false
            favoriteTableView.isHidden = true
        } else {
            favIsEmptyLabel.isHidden = true
            favIsEmptyImage.isHidden = true
            favIsEmptyDesc.isHidden = true
            favIsEmptyBtn.isHidden = true
            favoriteTableView.isHidden = false
        }
    }
    
    func showAlertMessage(message : String, title: String){
        let mAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        mAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(mAlert, animated: true, completion: nil)
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
