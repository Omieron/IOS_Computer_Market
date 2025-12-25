//
//  CategoriesVC.swift
//  OmerFarukAsil_Project
//
//  Created by Ömer Faruk Asil on 24.12.2025.
//

import UIKit

class CategoriesVC: UIViewController {

   
    @IBOutlet weak var categoryTableView: UITableView!
    
    
    let xmlCategoryData = DataSoruce()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.xmlCategoryData.populateFromXML()
        categoryTableView.reloadData()
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

        return cell
    }
}



