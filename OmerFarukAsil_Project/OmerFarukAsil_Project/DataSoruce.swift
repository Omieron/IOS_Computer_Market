//
//  DataSource.swift
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

    // Kategori ID'sine göre JSON dosya adını belirle
    func getJSONFileName(for categoryId: Int) -> String? {
        switch categoryId {
        case 100: return "gaming_monitor"
        case 101: return "gaming_keyboard"
        case 102: return "gaming_mouse"
        case 103: return "gaming_headset"
        case 110: return "cpu"
        case 111: return "ram"
        case 112: return "graphics_card"
        case 113: return "motherboard"
        case 114: return "case"
        case 120: return "gaming_laptop"
        case 121: return "gaming_ready_pc"
        
        case 200: return "office_monitor"
        case 201: return "office_laptop"
        case 202: return "office_mk"

        case 301: return "workstation_pc"
        case 302: return "workstation_monitor"
        default: return nil
        }
    }
    
    func populateProductsForCategories(_ categoryIds: [Int], completion: @escaping (Bool) -> Void) {
        products.removeAll()
        
        let group = DispatchGroup()
        
        for categoryId in categoryIds {
            guard let fileName = getJSONFileName(for: categoryId) else { continue }
            
            group.enter()
            loadProductsFromJSON(fileName: fileName) {
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            print("Toplam yüklenen ürün sayısı: \(self.products.count)")
            completion(true)
        }
    }
    
    func loadProductsFromJSON(fileName: String, completion: @escaping () -> Void) {
        
        let urlString = "https://raw.githubusercontent.com/Omieron/IOS_Computer_Market/main/Data/\(fileName).json"
        
        guard let url = URL(string: urlString) else {
            print("URL error for: \(fileName)")
            completion()
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("Network error for \(fileName): \(error)")
                completion()
                return
            }
            
            guard let data = data else {
                print("Data error for: \(fileName)")
                completion()
                return
            }

            guard let json = try? JSON(data: data) else {
                print("JSON parse error for: \(fileName)")
                completion()
                return
            }

            let productsArray = json["products"].arrayValue

            DispatchQueue.main.async {
                for item in productsArray {
                    let product = self.parseProduct(item)
                    self.products.append(product)
                }
                
                print("\(fileName) - Yüklenen ürün sayısı: \(productsArray.count)")
                completion()
            }

        }.resume()
    }

    func parseProduct(_ item: JSON) -> Product {

        let id = item["id"].intValue
        let name = item["name"].stringValue
        let brand = item["brand"].stringValue
        let description = item["description"].stringValue
        let price = item["price"].doubleValue
        let currency = item["currency"].stringValue
        let images = item["images"].arrayValue.map { $0.stringValue }

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
    
    func getAllLeafCategoryIds(from category: Category) -> [Int] {
        var ids: [Int] = []
        
        if category.children.isEmpty {
            ids.append(category.id)
        } else {
            for child in category.children {
                ids.append(contentsOf: getAllLeafCategoryIds(from: child))
            }
        }
        
        return ids
    }
}
