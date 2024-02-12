//
//  GroceryListItem.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 4/7/21.
//

import Foundation
import RealmSwift

class SavedGroceryRecipe: Object {
    @objc dynamic var name = ""
    var ingredients = List<Ingredient>()
}

class Ingredient: Object {
    @objc dynamic var name = ""
}

