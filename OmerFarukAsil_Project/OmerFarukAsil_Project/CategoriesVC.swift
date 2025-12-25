//
//  CategoriesVC.swift
//  OmerFarukAsil_Project
//
//  Created by Ömer Faruk Asil on 24.12.2025.
//

import UIKit
import Kingfisher

class CategoriesVC: UIViewController {

   
    @IBOutlet weak var categoryTableView: UITableView!
    
    
    let xmlCategoryData = DataSoruce()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache()
        
        xmlCategoryData.populateFromXML {
            self.categoryTableView.reloadData()
        }

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProducts",
           let vc = segue.destination as? ProductsVC,
           let category = sender as? Category {

            vc.selectedCategory = category
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

extension CategoriesVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return xmlCategoryData.rootCategories.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "CategoryRowCell",
            for: indexPath
        ) as! CategoryTableViewCell

        let category = xmlCategoryData.rootCategories[indexPath.row]
        cell.configure(with: category)

        cell.delegate = self

        return cell
    }

}

extension CategoriesVC: CategoryTableViewCellDelegate {

    func didSelectSubCategory(_ category: Category) {
        // sadece seçilen leaf
        performSegue(withIdentifier: "toProducts", sender: category)
    }

    func didTapSeeAll(for category: Category) {
        // büyük kategori
        performSegue(withIdentifier: "toProducts", sender: category)
    }
}





