//
//  CustomCategoriesCollectionViewCell.swift
//  OmerFarukAsil_Project
//
//  Created by Ömer Faruk Asil on 24.12.2025.
//

import UIKit

import Kingfisher

class CustomCategoriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func prepareForReuse() {
            super.prepareForReuse()
            imageView.kf.cancelDownloadTask()
            imageView.image = UIImage(named: "placeholder")
    }
    
    func configure(with category: Category) {
            titleLabel.text = category.name.capitalized

            if let urlString = category.imageURL,
               let url = URL(string: urlString) {

                imageView.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "placeholder"),
                    options: [
                        .transition(.fade(0.2)),
                        .cacheOriginalImage
                    ]
                )
            } else {
                imageView.image = UIImage(named: "placeholder")
            }
        }
    
}
