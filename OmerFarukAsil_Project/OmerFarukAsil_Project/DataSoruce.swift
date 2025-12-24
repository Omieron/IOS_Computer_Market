//
//  DataSoruce.swift
//  OmerFarukAsil_Project
//
//  Created by Ömer Faruk Asil on 24.12.2025.
//

import Foundation

class DataSoruce {
    
    var rootCategories: [Category] = []
    
    func numberOfCategories() -> Int {
        return rootCategories.count
    }

    func getCategoryLabelAtIndex(index: Int) -> String {
        return rootCategories[index].name
    }

    func numberOfItemsInCategory(index: Int) -> Int {
        return rootCategories[index].children.count
    }

    func itemsInCategory(index: Int) -> [Category] {
        return rootCategories[index].children
    }
    
    func populateFromXML() {

        if let url = URL(string: "https://raw.githubusercontent.com/Omieron/IOS_Computer_Market/main/Data/categories.xml") {

            if let data = try? Data(contentsOf: url) {

                let xml = SWXMLHash.parse(data)

                for item in xml["categories"]["category"].all {
                    let category = parseCategory(item, parentId: nil)
                    rootCategories.append(category)
                }
            } else {
                print("Data Error")
            }
        } else {
            print("Url Error")
        }
    }

    func parseCategory(_ item: XMLIndexer, parentId: Int?) -> Category {

        let id = Int(item.element?.attribute(by: "id")?.text ?? "0")!
        let name = item.element?.attribute(by: "name")?.text ?? "Unknown"

        let category = Category(id: id, name: name, parentId: parentId)

        for child in item["category"].all {
            let childCategory = parseCategory(child, parentId: id)
            category.children.append(childCategory)
        }

        return category
    }

    
    

    
    
    
    
}
