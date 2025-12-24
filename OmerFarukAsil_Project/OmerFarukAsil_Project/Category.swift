//
//  Category.swift
//  OmerFarukAsil_Project
//
//  Created by Ömer Faruk Asil on 24.12.2025.
//

import Foundation

class Category {
    var id: Int
    var name: String
    var parentId: Int?
    var children: [Category]

    init(
        id: Int,
        name: String,
        parentId: Int? = nil,
        children: [Category] = []
    ) {
        self.id = id
        self.name = name
        self.parentId = parentId
        self.children = children
    }
}
