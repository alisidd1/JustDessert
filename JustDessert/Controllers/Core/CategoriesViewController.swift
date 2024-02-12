//
//  CategoriesViewController.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 5/7/21.
//

import Foundation
import UIKit

class CategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var viewModels: [RecipeCellViewModel] = []
    private let model: CategoryCollectionViewCellViewModel
    let SECTION_HEADER_HEIGHT: CGFloat = 61

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(RecipeTableViewCell.self,
                           forCellReuseIdentifier: RecipeTableViewCell.identifier)
        return tableView
    }()
        
    init(viewModel: CategoryCollectionViewCellViewModel) {
        self.model = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)        
        self.title = model.name.uppercased()
        
            
        APICaller.shared.getRecipes { [weak self] recipes in
            DispatchQueue.main.async {
                let filteredRecipes = recipes.filter { $0.category == (self?.model.name) }
                self?.viewModels = filteredRecipes.compactMap({ model in
                    RecipeCellViewModel(
                        title: model.name,
                        imageURLString: model.image,
                        imageData: nil
                    )
                })
                self?.tableView.reloadData()
            }
       }
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
    
    func tableView(_ tableview: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
        let model = APICaller.shared.recipes[indexPath.row]
        
        let recipeViewController = RecipeViewController(recipe: model)
        navigationController?.pushViewController(recipeViewController, animated: true)
        recipeViewController.title = model.name
    }
    
    //model.name

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "American Typewriter", size: 24)
        header.textLabel?.textColor = UIColor.white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

