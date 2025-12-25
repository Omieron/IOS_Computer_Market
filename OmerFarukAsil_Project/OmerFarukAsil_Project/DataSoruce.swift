//
//  DataSoruce.swift
//  OmerFarukAsil_Project
//
//  Created by Ömer Faruk Asil on 24.12.2025.
//

import Foundation

class DataSoruce {
    
    var rootCategories: [Category] = []
    var products: [Product] = []
    
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
    
    func populateFromXML(completion: @escaping () -> Void) {

        URLCache.shared.removeAllCachedResponses()

        guard let url = URL(string: "https://raw.githubusercontent.com/Omieron/IOS_Computer_Market/main/Data/categories.xml") else {
            print("Url Error")
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                print("Data Error")
                return
            }

            let xml = SWXMLHash.parse(data)

            self.rootCategories.removeAll()

            for item in xml["categories"]["category"].all {
                let category = self.parseCategory(item, parentId: nil)
                self.rootCategories.append(category)
            }

            DispatchQueue.main.async {
                completion()
            }

        }.resume()
    }


    func parseCategory(_ item: XMLIndexer, parentId: Int?) -> Category {

        let id = Int(item.element?.attribute(by: "id")?.text ?? "0")!
        let name = item.element?.attribute(by: "name")?.text ?? "Unknown"
        let imageURL = item.element?.attribute(by: "image")?.text

        let category = Category(
            id: id,
            name: name,
            parentId: parentId,
            imageURL: imageURL
        )
        print(name)
        for child in item["category"].all {
            let childCategory = parseCategory(child, parentId: id)
            category.children.append(childCategory)
        }

        return category
    }
    
    func numberOfProducts() -> Int {
            return products.count
        }

        func productAt(index: Int) -> Product {
            return products[index]
        }

    
    func populateFromJSON(completion: @escaping () -> Void) {

        guard let url = URL(string:
            "https://raw.githubusercontent.com/Omieron/IOS_Computer_Market/main/Data/products.json")
        else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in

            if let error = error {
                print("Network error:", error)
                return
            }

            guard let data = data else { return }

            do {
                let jsonArray = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] ?? []

                self.products.removeAll()

                for item in jsonArray {
                    let product = self.parseProduct(item)
                    self.products.append(product)
                }

                DispatchQueue.main.async {
                    print("Product count:", self.products.count)
                    completion()
                }

            } catch {
                print("JSON Parse Error:", error)
            }

        }.resume()
    }


        func parseProduct(_ item: [String: Any]) -> Product {

            let id = item["id"] as? Int ?? 0
            let name = item["name"] as? String ?? "Unknown"
            let brand = item["brand"] as? String ?? "Unknown"
            let description = item["description"] as? String ?? ""
            let price = item["price"] as? Double ?? 0
            let currency = item["currency"] as? String ?? ""
            let images = item["images"] as? [String] ?? []

            let product = Product(
                id: id,
                name: name,
                brand: brand,
                description: description,
                price: price,
                currency: currency,
                images: images
            )

            return product
        }
    
}
