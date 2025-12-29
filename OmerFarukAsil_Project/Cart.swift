//
//  Cart.swift
//  OmerFarukAsil_Project
//
//  Created by Ömer Faruk Asil on 29.12.2025.
//

import CoreData
import Foundation

@objc(Cart)
public class Cart: NSManagedObject {

    static func create(in context: NSManagedObjectContext,
                       brand: String,
                       name: String,
                       currency: String,
                       desc: String,
                       id: NSNumber,
                       image: String,
                       price: NSNumber) -> Cart {

        let cartObject = NSEntityDescription.insertNewObject(
            forEntityName: "Cart",
            into: context
        ) as! Cart

        cartObject.brand = brand
        cartObject.name = name
        cartObject.currency = currency
        cartObject.desc = desc
        cartObject.id = id.int64Value
        cartObject.image = image
        cartObject.price = price.doubleValue

        return cartObject
    }
}
