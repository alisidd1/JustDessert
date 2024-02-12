//
//  SearchResultViewController.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 4/5/21.
//

import Foundation
import UIKit

protocol SearchResultViewControllerDelegate: AnyObject {
    func searchResultViewController(_ resultContoller: SearchResultViewController,
                                    didSelectItemWith model: Recipe)
}

class SearchResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    weak var delegate:  SearchResultViewControllerDelegate?
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(RecipeTableViewCell.self,
                           forCellReuseIdentifier: RecipeTableViewCell.identifier)
        return tableView
    }()
    
    private var viewModels: [RecipeCellViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    public func update(filterdViewModels: [RecipeCellViewModel]) {
        // sort and present viewModel per each searchText value
        viewModels = filterdViewModels
        tableView.reloadData()
    }
    
    // MARK: - Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModels[indexPath.row]
                
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RecipeTableViewCell.identifier,
            for: indexPath
        ) as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel)
        return cell
    }
    
    // present selected recipe/row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // deselect row
        tableView.deselectRow(at: indexPath, animated: true)
        let recipes = APICaller.shared.recipes
        let viewModel = viewModels[indexPath.row]
        guard let selectedRecipe = recipes.first(where: {
            $0.name == viewModel.title
        }) else {
            return
        }
        // use delegate to tell searchVC of selected VM
        delegate?.searchResultViewController(self, didSelectItemWith: selectedRecipe)
    }
}

