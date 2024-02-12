//
//  Models.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 3/21/21.
//

import Foundation

// Below model is returend when you query for a single recipe

struct RecipeInfo: Codable {
    let id: String
    let name: String
    let image: String
    let category: String
    let description: String
    let ingredients: [String]
    let directions: [String]
}

struct ApiRecipeResponse: Codable {
    let data: [RecipeInfo]
}

//  model below is returned when you have list of all recipes
public struct Recipe: Codable {
    let id: String
    let name: String
    let image: String
    let category: String
}

struct RecipeListResponse: Codable {
    let data: [Recipe]
}

struct TodaysRecipeDate {
    let dateString: String
}
