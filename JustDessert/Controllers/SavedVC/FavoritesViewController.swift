//
//  FvoritesViewController.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 4/11/21.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var viewModels: [RecipeCellViewModel] = []
    private var recipes = [FavoriteRecipe]()
    
    private let banner: GADBannerView = {
       let banner = GADBannerView()
        banner.backgroundColor =  .secondarySystemBackground
        banner.adUnitID = "ca-app-pub-6335449243315858/7789209461"
        banner.load(GADRequest())
        return banner
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(RecipeTableViewCell.self,
                           forCellReuseIdentifier: RecipeTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        banner.rootViewController = self
        view.addSubview(banner)
        NotificationCenter.default.addObserver(self, selector: #selector(newFavoriteAdded), name: NSNotification.Name("FavoriteAdded"), object: nil)
        getSavedRecipes()
    }
    
    @objc func newFavoriteAdded() {
        getSavedRecipes()
    }

    private func getSavedRecipes() {
        DatabaseManager.shared.getSavedRecipe(completion: { [weak self] (recipes) in
            self?.recipes = recipes
            self?.viewModels = recipes.compactMap({ model in
                RecipeCellViewModel(
                    title: model.name,
                    imageURLString: model.image,
                    imageData: nil
                )
            }).sorted(by: { first, second in
                return first.title < second.title
            })
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
    }
    
    // MARK: - Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.deselectRow(at: indexPath, animated: true)
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
        let viewModel = viewModels[indexPath.row]
        guard let recipe = APICaller.shared.recipes.first(where: {
            $0.name.lowercased() == viewModel.title.lowercased()
        }) else {
            return
        }
        let recipeViewController = RecipeViewController(recipe: recipe)
        navigationController?.pushViewController(recipeViewController, animated: true)
        recipeViewController.title = recipe.name
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            tableView.beginUpdates()
            viewModels.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            DatabaseManager.shared.deleteRecipe(recipe: recipes[indexPath.row])
        }
    }
 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        banner.frame = CGRect(x: 0, y: view.height-130, width: view.width, height: 50).integral
    }
}
