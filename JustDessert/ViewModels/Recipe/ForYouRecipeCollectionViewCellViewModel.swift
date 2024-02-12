//
//  ForYouRecipeCollectionViewCellViewModel.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 4/28/21.
//

import Foundation

final class ForYouRecipeCollectionViewCellViewModel {
    let viewModels: [RecipeCollectionViewCellViewModel]
    init(viewModels: [RecipeCollectionViewCellViewModel]) {
        self.viewModels = viewModels
    }
}
