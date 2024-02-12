//
//  RecipeCollectionViewCellViewModel.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 4/23/21.
//

import Foundation


//View Model for Browse section Cell
final class RecipeCollectionViewCellViewModel {
    let name: String
    let imageURLString: String
    var imageData: Data?
    
    init(
        name: String,
        imageURLString: String,
        imageData: Data?
    ) {
        self.name = name
        self.imageURLString = imageURLString
        self.imageData = imageData
    }
}
