//
//  Product.swift
//  OmerFarukAsil_Project
//
//  Created by Ömer Faruk Asil on 25.12.2025.
//

import Foundation

class Product {
    
    var id: Int
    var name: String
    var brand: String
    var description: String
    var price: Double
    var currency: String
    var images: [String]

    init(
        id: Int,
        name: String,
        brand: String,
        description: String,
        price: Double,
        currency: String,
        images: [String]
    ) {
        self.id = id
        self.name = name
        self.brand = brand
        self.description = description
        self.price = price
        self.currency = currency
        self.images = images
    }
}
