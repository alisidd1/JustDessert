//
//  BrowseSectionsType.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 4/23/21.
//

import Foundation

enum BrowseSectionsType {
    case forYou(viewModel: ForYouRecipeCollectionViewCellViewModel)
    case category(viewModel: CategoryTableViewCellViewModel)
    case beHealthy(viewModel: BeHealthyRecipeCollectionViewCellViewModel)
    case pieTime(viewModel: PieTimeRecipeCollectionViewCellViewModel)
    case trendingFruit(viewModel: TrendingFruitRecipeCollectionViewCellViewModel)
    
    case favoriteCakes(viewModels: [RecipeCellViewModel])
    case chocolateAddicts(viewModels: [RecipeCellViewModel])
    case cookieTime(viewModels: [RecipeCellViewModel])

    var title: String {
        switch self {
        case .forYou:
            return "For You"
        case .category:
            return "Category"
        case .favoriteCakes:
            return "Favorite Cakes"
        case .beHealthy:
            return "Be Healthy"
        case .chocolateAddicts:
            return "Chocolate Addicts"
        case .cookieTime:
            return "Cookie Time"
        case .pieTime:
            return "Pie Time"
        case .trendingFruit:
            return "Trending Fruit"
        }
    }
}
