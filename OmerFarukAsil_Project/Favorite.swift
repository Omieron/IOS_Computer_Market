//
//  Favorite.swift
//  OmerFarukAsil_Project
//
//  Created by Ömer Faruk Asil on 29.12.2025.
//

import CoreData
import Foundation

@objc(Favorite)
public class Favorite: NSManagedObject {

    static func create(in context: NSManagedObjectContext,
                       brand: String,
                       name: String,
                       currency: String,
                       desc: String,
                       id: NSNumber,
                       image: String,
                       price: NSNumber) -> Favorite {

        let favoriteObject = NSEntityDescription.insertNewObject(
            forEntityName: "Favorite",
            into: context
        ) as! Favorite

        favoriteObject.brand = brand
        favoriteObject.name = name
        favoriteObject.currency = currency
        favoriteObject.desc = desc
        favoriteObject.id = id.int64Value
        favoriteObject.image = image
        favoriteObject.price = price.doubleValue

        return favoriteObject
    }
}
