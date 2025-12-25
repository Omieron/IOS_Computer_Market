//
//  CategoryTableViewCell.swift
//  OmerFarukAsil_Project
//
//  Created by Ömer Faruk Asil on 25.12.2025.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    private var items: [Category] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
    }

    func configure(with category: Category) {
        categoryLabel.text = category.name
        items = category.children
        categoryCollectionView.reloadData()
        
    }

}

extension CategoryTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "SubCategoryCell",
            for: indexPath
        ) as! CustomCategoriesCollectionViewCell

        let category = items[indexPath.item]

        cell.configure(with: category)

        return cell
    }
}


