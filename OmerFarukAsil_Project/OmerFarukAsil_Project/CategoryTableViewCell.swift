//
//  CategoryTableViewCell.swift
//  OmerFarukAsil_Project
//
//  Created by Ömer Faruk Asil on 25.12.2025.
//

import UIKit

protocol CategoryTableViewCellDelegate: AnyObject {
    func didSelectSubCategory(_ category: Category)
    func didTapSeeAll(for category: Category)
}

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    weak var delegate: CategoryTableViewCellDelegate?
    
    private var parentCategory: Category?
    private var items: [Category] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
    }

    func configure(with category: Category) {
        parentCategory = category
        categoryLabel.text = category.name
        categoryLabel.text = category.name
        items = category.children.flatMap { $0.children }
        categoryCollectionView.reloadData()
        
    }
    
    @IBAction func seeAllTapped(_ sender: UIButton) {
        guard let parentCategory else { return }
        delegate?.didTapSeeAll(for: parentCategory)
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
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {

        let selectedCategory = items[indexPath.item]
        delegate?.didSelectSubCategory(selectedCategory)
    }

}


