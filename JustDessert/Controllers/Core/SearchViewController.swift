//
//  SearchViewController.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 3/10/21.
//

import GoogleMobileAds
import Foundation
import UIKit

struct SearchRecipeSection{
    let title: String
    let viewModels: [RecipeCellViewModel]
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    private var allRecipes = [Recipe]()
    private var sections: [SearchRecipeSection] = []
    let searchController = UISearchController(searchResultsController: SearchResultViewController())
        
    private let banner: GADBannerView = {
       let banner = GADBannerView()
        banner.backgroundColor = .secondarySystemBackground
        banner.adUnitID = "ca-app-pub-6335449243315858/7789209461"
        banner.load(GADRequest())
        return banner
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(RecipeTableViewCell.self,
                           forCellReuseIdentifier: RecipeTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        banner.rootViewController = self
        view.addSubview(banner)

        fetchData()
    }
    
    private func fetchData() {
        APICaller.shared.getRecipes { [weak self] allRecipes in
            DispatchQueue.main.async { [self] in
                let allCategories: [String] = allRecipes.compactMap({
                    $0.category
                })
                let categories = Array(Set(allCategories))

                let sections: [SearchRecipeSection] = categories.compactMap({ category in
                    let viewModels: [RecipeCellViewModel] = allRecipes.filter({ recipe in
                        recipe.category == category
                    }).compactMap({ recipe in
                        return RecipeCellViewModel(title: recipe.name,
                                                   imageURLString: recipe.image,
                                                   imageData: nil)
                    }).sorted(by: { first, second in
                        return first.title < second.title
                    })
                    return SearchRecipeSection(title: category, viewModels: viewModels)
                })
                self?.sections = sections
                self?.tableView.reloadData()
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text,
              !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        // Filter viewModels
        let filterdViewModels = sections.filter({ section in
            let viewModels = section.viewModels
            return viewModels.contains(where: { viewModel in
                return viewModel.title.hasPrefix(searchText)
            })
        }).compactMap { section in
            return section.viewModels
        }
        .flatMap({ return $0 })
        .filter({
            $0.title.hasPrefix(searchText)
        })

//        // Filter viewModels
//        let filterdViewModels = sections.filter({ section in
//            let viewModels = section.viewModels
//            return viewModels.contains(where: { viewModel in
//                return viewModel.title.hasPrefix(searchText)
//            })
//        }).compactMap({ section in
//            return section.viewModels
//        })
//        .flatMap({ return $0 })
//        .filter({
//            $0.title.hasPrefix(searchText)
//        })

        
        // Give to result controller
        let searchResultViewController = searchController.searchResultsController as? SearchResultViewController
        searchResultViewController?.delegate = self
        searchResultViewController?.update(filterdViewModels: filterdViewModels)
    }
       
    // MARK: - Table
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = sections[indexPath.section].viewModels[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RecipeTableViewCell.identifier,
            for: indexPath
        ) as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableview: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
        let viewModel = sections[indexPath.section].viewModels[indexPath.row]
        guard let model = APICaller.shared.recipes.first(where: {
            $0.name.lowercased() == viewModel.title.lowercased()
        }) else {
            return
        }
        
        let recipeViewController = RecipeViewController(recipe: model)
        navigationController?.pushViewController(recipeViewController, animated: true)
        recipeViewController.title = model.name
    }
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].viewModels.count
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        banner.frame = CGRect(x: 0, y: view.height-130, width: view.width, height: 50).integral
    }
}

extension SearchViewController: SearchResultViewControllerDelegate {
    func searchResultViewController(_ resultContoller: SearchResultViewController, didSelectItemWith model: Recipe) {
        let recipeViewController = RecipeViewController(recipe: model)
        navigationController?.pushViewController(recipeViewController, animated: true)
        recipeViewController.title = model.name
    }
}


