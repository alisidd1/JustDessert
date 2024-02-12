//
//  CellType.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 3/23/21.
//

import Foundation

enum CellType {
    case ingredient(viewModel: IngredientViewModel)
    case direction(viewModel: directionViewModel)
    case button(viewModel: ButtonViewModel)
    case name(viewModel: RecipeNameTableViewCellViewModel)
    case category(viewModel: RecipeCategoryViewModel)
    case description(viewModel: RecipeDescriptionViewModel)
}

struct RecipeCategoryViewModel { // RecipeCategoryTableViewCellViewModel
    let RecipeCategoryViewModel: String
}

