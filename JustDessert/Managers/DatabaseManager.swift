//
//  DatabaseManager.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 4/6/21.
//

import Foundation
import RealmSwift

final class DatabaseManager {
    static var shared = DatabaseManager()
    private let realm = try? Realm()
    public var recipes: [Recipe] = []
    
    public func saveRecipe(model: Recipe) {        
        APICaller.shared.getRecipeDetails(model: model) { (recipeInfo) in
            DispatchQueue.main.async {
                guard let recipeInfo = recipeInfo else {
                    return
                }
                let recipeViewController = RecipeViewController(recipe: model)
                recipeViewController.configureViewModels(recipeInfo: recipeInfo)
            }
        }
        
        let favoriteRecipe = FavoriteRecipe(id: model.id, name: model.name, image: model.image, category: model.category)
        
        // save this recipe, later to be rendered on "saved" controller's "Favorite" child controller
        guard let realm = realm else {
            return
        }
        realm.beginWrite()
        realm.add(favoriteRecipe)
        do {
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    public func getSavedRecipe(completion: ([FavoriteRecipe]) -> Void) {
        guard let realm = realm else {
            return
        }
        
        let savedRecipe: [FavoriteRecipe] = realm.objects(FavoriteRecipe.self).map { $0 }
        completion(savedRecipe)
    }
    
    public func getSavedGroceryList(completion: ([SavedGroceryRecipe]) -> Void) {
        guard let realm = realm else {
            return
        }
        
        let savedGroceryList: [SavedGroceryRecipe] = realm.objects(SavedGroceryRecipe.self).map { $0 }
        completion(savedGroceryList)
    }
    
    // did saveGroceryList with Afarz 4/13/21
    public func saveGroceryList(recipeName: String, ingredients: [String]) {
        
        // begin realm write transactions
        guard let realm = realm else {
            return
        }
        realm.beginWrite()
        
        // instantiate a model for SavedGroceryRecipe
        let savedGroceryRecipe = SavedGroceryRecipe()
        
        // asign recipe name
        savedGroceryRecipe.name = recipeName
        
        // create ingredient model for every ingredient string
        ingredients.forEach { ingredient in
            let ingredientModel = Ingredient()
            ingredientModel.name = ingredient
            savedGroceryRecipe.ingredients.append(ingredientModel)
        }
        
        realm.add(savedGroceryRecipe)
        do {
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func deleteGroceryIngredient(ingredient: Ingredient) {
        guard let realm = realm else {
            return
        }
        realm.beginWrite()
        realm.delete(ingredient)
        do {
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func deleteRecipe(recipe: FavoriteRecipe) {
        // begin realm write transactions
        guard let realm = realm else {
            return
        }
        realm.beginWrite()
        realm.delete(recipe)
        do {
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func saveTodaysRecipeDate(dateSaved: String) {
        // begin realm write transactions
        guard let realm = realm else {
            return
        }
        realm.beginWrite()
        let todaysRecipeDateSaved = TodaysRecipeDateSaved()
        todaysRecipeDateSaved.dateSaved = dateSaved
        realm.add(todaysRecipeDateSaved)
        do {
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
//    func getTodyasRecipeDate(completion: ((String) -> Void)) {
//        guard let realm = realm else {
//            return
//        }
//        let todaysRecipeDateSaved: TodaysRecipeDateSaved =
//            realm.objects(TodaysRecipeDateSaved.self)
//        completion(todaysRecipeDateSaved.dateSaved)
//    }
}
