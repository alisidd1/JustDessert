//
//  recipeCellViewModel.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 3/24/21.
//

import Foundation

//View Model for recipeCell
final class RecipeCellViewModel {
    let title: String
    let imageURLString: String
    var imageData: Data?
    
    init(
        title: String,
        imageURLString: String,
        imageData: Data?
    ) {
        self.title = title
        self.imageURLString = imageURLString
        self.imageData = imageData
    }
}

