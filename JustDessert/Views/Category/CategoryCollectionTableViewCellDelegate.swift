//
//  CategoryCollectionTableViewCellDelegate.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 5/6/21.
//

import Foundation
import UIKit

protocol CategoryCollectionTableViewCellDelegte: AnyObject {
    func didTapCategoryCollectionItem(viewModel: CategoryCollectionViewCellViewModel)
}
