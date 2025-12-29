//
//  CartVC.swift
//  OmerFarukAsil_Project
//
//  Created by Ömer Faruk Asil on 29.12.2025.
//

import UIKit
import CoreData
import Kingfisher
import AudioToolbox

class CartVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var cartTableView: UITableView!
    
    @IBOutlet weak var cartIsEmptyLabel: UILabel!
    
    @IBOutlet weak var purchaseBtn: UIButton!
    
    @IBOutlet weak var cartIsEmptyImage: UIImageView!
    
    @IBOutlet weak var cartIsEmptyDescLabel: UILabel!
    
    @IBOutlet weak var cartIsEmptyBtn: UIButton!
    
    var mCart: [Cart] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Recommended way
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCustomTableViewCell
        
        // Get the Student for this index
        let cart = mCart[indexPath.row]
        
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        cartTableView.reloadData()
    }
    
    @IBAction func browseProductsTapped(_ sender: UIButton) {
        tabBarController?.selectedIndex = 1
    }
    
    @IBAction func pressedCheckout(_ sender: UIButton) {
        clearCart()
        showAlertMessage()
    }
    
    func fetchData(){
        
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
        
        CheckIsDataAvailable()
        
    }
    
    func deleteCartItem(at indexPath: IndexPath) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate)
            .persistentContainer.viewContext

        let itemToDelete = mCart[indexPath.row]

        context.delete(itemToDelete)

        do {
            try context.save()
            mCart.remove(at: indexPath.row)
            cartTableView.deleteRows(at: [indexPath], with: .automatic)
            CheckIsDataAvailable()
        } catch {
            print("Delete error:", error)
        }
    }
    
    func clearCart() {

        let context = (UIApplication.shared.delegate as! AppDelegate)
            .persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Cart.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()

            mCart.removeAll()
            cartTableView.reloadData()
            CheckIsDataAvailable()
        } catch {
            print("Clear cart error:", error)
        }
    }
    
    func CheckIsDataAvailable(){
        if mCart.isEmpty == true{
            cartIsEmptyLabel.isHidden = false
            cartIsEmptyImage.isHidden = false
            cartIsEmptyDescLabel.isHidden = false
            cartIsEmptyBtn.isHidden = false
            cartTableView.isHidden = true
            purchaseBtn.isHidden = true
        } else {
            cartIsEmptyLabel.isHidden = true
            cartIsEmptyImage.isHidden = true
            cartIsEmptyDescLabel.isHidden = true
            cartIsEmptyBtn.isHidden = true
            cartTableView.isHidden = false
            purchaseBtn.isHidden = false
        }
    }
    
    func showAlertMessage(){
        let mAlert = UIAlertController(title: "Success", message: "Your order has been placed successfully.", preferredStyle: .alert)
        
        mAlert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        
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
