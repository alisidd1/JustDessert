//
//  GroceryViewController.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 4/11/21.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class GroceryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var sections: [GrocerySectionViewModel] = []
    private var groceryList = [SavedGroceryRecipe]()
    
    private let banner: GADBannerView = {
       let banner = GADBannerView()
        banner.backgroundColor =  .secondarySystemBackground
        banner.adUnitID = "ca-app-pub-6335449243315858/7789209461"
        banner.load(GADRequest())
        return banner
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(GroceryIngredientTableViewCell.self, forCellReuseIdentifier: "GroceryIngredientTableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .systemGray6
        view.addSubview(tableView)
        banner.rootViewController = self
        view.addSubview(banner)
        NotificationCenter.default.addObserver(self, selector: #selector(newIngredientsAdded), name: NSNotification.Name("IngredientsAdded"), object: nil)
        getGroceryList()
    }
    
    @objc func newIngredientsAdded() {
        getGroceryList()
    }
    
    private func getGroceryList() {
        DatabaseManager.shared.getSavedGroceryList(completion: { [weak self] (groceryList) in
            self?.groceryList = groceryList
            self?.sections = groceryList.compactMap({ groceryRecipe  in
                GrocerySectionViewModel(
                    sectionTitle: groceryRecipe.name,
                    ingredientViewModels: groceryRecipe.ingredients.compactMap({
                        IngredientViewModel(ingredient: $0.name, number: 0)
                    })
                )
            })
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
    }
    
    // MARK: - Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].ingredientViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "GroceryIngredientTableViewCell",
            for: indexPath
        ) as? GroceryIngredientTableViewCell else {
            return UITableViewCell()
        }
        
        let sectionIndex = indexPath.section
        let rowIndex = indexPath.row
        let section = sections[sectionIndex]
        let viewModel = section.ingredientViewModels[rowIndex]
        
        cell.configure(with: viewModel)
        return cell
    }
    
    func numberOfSections(in recipeTableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].sectionTitle
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let rowIndex = indexPath.row
            let sectionIndex = indexPath.section
            
            tableView.beginUpdates()
            sections[sectionIndex].ingredientViewModels.remove(at: rowIndex)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            
            let entry = groceryList[indexPath.section]
            let ingredient = entry.ingredients[indexPath.row]
            DatabaseManager.shared.deleteGroceryIngredient(ingredient: ingredient)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        banner.frame = CGRect(x: 0, y: view.height-130, width: view.width, height: 50).integral
    }
}

