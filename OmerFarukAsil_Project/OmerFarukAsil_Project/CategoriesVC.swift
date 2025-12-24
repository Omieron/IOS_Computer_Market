//
//  CategoriesVC.swift
//  OmerFarukAsil_Project
//
//  Created by Ömer Faruk Asil on 24.12.2025.
//

import UIKit

class CategoriesVC: UIViewController {

    @IBOutlet weak var gamingCollectionView: UICollectionView!
    
    
    @IBOutlet weak var officeCollectionView: UICollectionView!
    
    
    @IBOutlet weak var workstationCollectionView: UICollectionView!
    
    let xmlCategoryData = DataSoruce()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.xmlCategoryData.populateFromXML()
        self.gamingCollectionView.reloadData()
        self.officeCollectionView.reloadData()
        self.workstationCollectionView.reloadData()
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

extension CategoriesVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {

        if collectionView == gamingCollectionView {
            return xmlCategoryData.rootCategories[0].children.count
        } else if collectionView == officeCollectionView {
            return xmlCategoryData.rootCategories[1].children.count
        } else {
            return xmlCategoryData.rootCategories[2].children.count
        }
    }

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "SubCategoryCell",
            for: indexPath
        ) as! CustomCategoriesCollectionViewCell

        let category: Category

        if collectionView == gamingCollectionView {
            category = xmlCategoryData.rootCategories[0].children[indexPath.item]
        } else if collectionView == officeCollectionView {
            category = xmlCategoryData.rootCategories[1].children[indexPath.item]
        } else {
            category = xmlCategoryData.rootCategories[2].children[indexPath.item]
        }

        cell.titleLabel.text = category.name.capitalized
        return cell
    }

    
}
