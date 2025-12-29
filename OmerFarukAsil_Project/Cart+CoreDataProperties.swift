//
//  Cart+CoreDataProperties.swift
//  OmerFarukAsil_Project
//
//  Created by Ömer Faruk Asil on 29.12.2025.
//

import CoreData
import Foundation

extension Cart {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cart> {
        return NSFetchRequest<Cart>(entityName: "Cart")
    }
    
    @NSManaged public var brand: String?
    @NSManaged public var name: String?
    @NSManaged public var currency: String?
    @NSManaged public var desc: String?
    @NSManaged public var id: Int64
    @NSManaged public var image: String?
    @NSManaged public var price: Double
}

