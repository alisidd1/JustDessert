//
//  FavoriteReipe.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 4/7/21.
//

import Foundation
import RealmSwift

class FavoriteRecipe: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var category: String = ""
    
    
    init(id: String, name: String, image: String, category: String) {
        self.id = id
        self.name = name
        self.image = image
        self.category = category
    }

    required override init() {

    }
}

