//
//  BrowseCollectionTableViewCellDelegte.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 5/1/21.
//

import Foundation
import UIKit

protocol BrowseCollectionTableViewCellDelegte: AnyObject {
    func didTapRecipeCollectionItem(viewModel: RecipeCollectionViewCellViewModel)
}
