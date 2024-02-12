//
//  RecipeViewController.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 3/16/21.
//  Displays the recipe details after user selects an item (row)
//  from the displayed list.

import Foundation
import UIKit
import GoogleMobileAds

final class RecipeViewController: UIViewController, ButtonTableViewCellDelegate, GADFullScreenContentDelegate {
    let SECTION_HEADER_HEIGHT: CGFloat = 61
    private var interstitialAd: GADInterstitialAd?

    private let banner: GADBannerView = {
       let banner = GADBannerView()
        banner.backgroundColor =  .secondarySystemBackground
        banner.adUnitID = "ca-app-pub-6335449243315858/7789209461"
        banner.load(GADRequest())
        return banner
    }()
 
    private let model: Recipe
    private var recipeInfo: RecipeInfo?
    private var sections = [[CellType]]()
    
    private let recipeTableView: UITableView = {
        let recipeTableView = UITableView(frame: .zero, style: .grouped)
        recipeTableView.register(IngredientTableViewCell.self, forCellReuseIdentifier: IngredientTableViewCell.identifier)
        recipeTableView.register(DirectionViewModel.self, forCellReuseIdentifier: "DirectionViewModel")
        recipeTableView.register(ButtonTableViewCell.self, forCellReuseIdentifier:"ButtonTableViewCell")
        recipeTableView.register(RecipeNameTableViewCell.self, forCellReuseIdentifier:"RecipeNameTableViewCell")
        recipeTableView.register(CategoryCollectionTableViewCell.self, forCellReuseIdentifier:"CategoryCollectionTableViewCell")
        recipeTableView.register(RecipeDescriptionTableViewCell.self, forCellReuseIdentifier:"RecipeDescriptionTableViewCell")
        return recipeTableView
    }()
    
    // MARK: - Init
    
    init(recipe: Recipe) {
        self.model = recipe
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        recipeTableView.dataSource = self
        recipeTableView.delegate = self
        view.addSubview(recipeTableView)
        recipeTableView.tableHeaderView = RecipeTableHeaderView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width))
        APICaller.shared.getRecipeDetails(model: model) { [weak self] (recipeInfo) in
            DispatchQueue.main.async {
                guard let recipeInfo = recipeInfo else { return }
                self?.configureViewModels(recipeInfo: recipeInfo)
            }
        }
        
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-6335449243315858/2037231471",
                               request: request,
                               completionHandler: { [self] ad, error in
                                if let error = error {
                                    print("cannot load ads - error = \(error.localizedDescription)")
                                    return
                                }
                                interstitialAd = ad
                                interstitialAd?.fullScreenContentDelegate = self
                               })

        banner.rootViewController = self
        view.addSubview(banner)
    }
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
      print("Ad did fail to present full screen content.")
    }

    /// Tells the delegate that the ad presented full screen content.
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
      print("Ad did present full screen content.")
    }

    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
      print("Ad did dismiss full screen content.")
    }

    func configureViewModels(recipeInfo: RecipeInfo) {
        self.recipeInfo = recipeInfo
        let name = recipeInfo.name
        let category = recipeInfo.category.uppercased()
        let description = recipeInfo.description
        let ingredients = recipeInfo.ingredients
        let directions = recipeInfo.directions
        let imageURL = recipeInfo.image
        
        (recipeTableView.tableHeaderView as? RecipeTableHeaderView)?.configure(urlString: imageURL)
        
        let recipeCategoryViewSection: [CellType] = [
            .category(viewModel: RecipeCategoryViewModel(RecipeCategoryViewModel: category))
        ]
        
        let recipeNameViewSection: [CellType] = [
            .name(viewModel: RecipeNameTableViewCellViewModel(RecipeNameTableViewCellViewModelLabel: name))
        ]
        
        let favButtonSection: [CellType] = [
            .button(viewModel: ButtonViewModel(buttonTitle: "Add Favorite", buttonColor: .systemBlue, buttonType: .favorite))
        ]
        
        let groceryListButtonSection: [CellType] = [
            .button(viewModel: ButtonViewModel(buttonTitle: "Add To Grocery List", buttonColor: .systemGreen, buttonType: .grocery))
        ]
        
        var IngredientViewModels =  [IngredientViewModel]()
        
        for x in 0..<ingredients.count {
            let viewModel = IngredientViewModel(ingredient: ingredients[x],
                                                number: x+1)
            IngredientViewModels.append(viewModel)
        }
        
        let ingredientSection: [CellType] = IngredientViewModels.compactMap({
            return CellType.ingredient(viewModel: $0)
        })
        
        let recipeDescriptionViewSection: [CellType] = [
            .description(viewModel: RecipeDescriptionViewModel(RecipeDescriptionViewModel: description))
        ]
        
        var directionViewModels = [directionViewModel]()
        for x in 0..<directions.count {
            guard !directions[x].trimmingCharacters(in: .whitespaces).isEmpty else {
                continue
            }
            let viewModel = directionViewModel(direction: directions[x],
                                               number: x+1)
            directionViewModels.append(viewModel)
        }
        let directionSection: [CellType] = directionViewModels.compactMap({
            return CellType.direction(viewModel: $0)
        })
        
        sections.append(recipeNameViewSection)
        sections.append(recipeCategoryViewSection)
        sections.append(favButtonSection)
        sections.append(recipeDescriptionViewSection)
        sections.append(ingredientSection)
        sections.append(groceryListButtonSection)
        sections.append(directionSection)
        recipeTableView.reloadData()
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        recipeTableView.frame = CGRect(x: 0, y: 70, width: view.width, height: view.height-115)
        banner.frame = CGRect(x: 0, y: view.height-130, width: view.width, height: 50).integral
    }
    
    func buttonTableViewCellDidTapButton(_ cell: ButtonTableViewCell, viewModel: ButtonViewModel) {
        switch viewModel.buttonType {
        case .favorite:
            saveToDatabaseAndPresentAlert(viewModel: viewModel)
            break
        case .grocery:
            saveToDatabaseAndPresentAlert(viewModel: viewModel)

            break
        }
    }
    
    func saveToDatabaseAndPresentAlert(viewModel: ButtonViewModel) {
        let titleStr: String
        switch viewModel.buttonType {
        case .favorite:
            // save recipe
            DatabaseManager.shared.saveRecipe(model: model)
            titleStr = "This recipe has been added to your favorites."
            NotificationCenter.default.post(name: Notification.Name("FavoriteAdded"), object: nil)
            break
        case .grocery:
            //save grocery list
            guard let name = recipeInfo?.name,
                  let ingredients = recipeInfo?.ingredients else{
                return
            }
            DatabaseManager.shared.saveGroceryList(recipeName: name, ingredients: ingredients)
            titleStr = "These ingredients have been added to your grocery list."
            NotificationCenter.default.post(name: Notification.Name("IngredientsAdded"), object: nil)
            break
        }
        
        let alert = UIAlertController(
            title: viewModel.buttonTitle,
            message: titleStr,
            preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Got It", style: .cancel, handler: { action in
        })
        alert.addAction(ok)
        //RecipeViewController
        present(alert, animated: true)
        
    }
}

extension RecipeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ recipeTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    func numberOfSections(in recipeTableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 3:
            return "Description"
        case 4:
            return "Ingredients"
        case 6:
            return "Directions"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "American Typewriter", size: 24)
        header.textLabel?.textColor = UIColor.white
    }
    
    internal func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SECTION_HEADER_HEIGHT
    }

    func tableView(_ recipeTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = sections[indexPath.section][indexPath.row]
        switch cellType {
        case .ingredient(let viewModel):
            guard let cell = recipeTableView.dequeueReusableCell(
                withIdentifier: IngredientTableViewCell.identifier,
                for: indexPath
            ) as? IngredientTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: viewModel)
            return cell
            
        case .direction(let viewModel):
            guard let cell = recipeTableView.dequeueReusableCell(
                withIdentifier: DirectionViewModel.identifier,
                for: indexPath
            ) as? DirectionViewModel else {
                return UITableViewCell()
            }
            cell.configure(with: viewModel, indexPath: indexPath.row)
            return cell
            
        case .button(viewModel: let viewModel):
            guard let cell = recipeTableView.dequeueReusableCell(
                withIdentifier: ButtonTableViewCell.identifier,
                for: indexPath
            ) as? ButtonTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: viewModel)
            cell.delegate = self
            return cell
            
        case .name(viewModel: let viewModel):
            guard let cell = recipeTableView.dequeueReusableCell(
                withIdentifier: RecipeNameTableViewCell.identifier,
                for: indexPath
            ) as? RecipeNameTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: viewModel, indexPath: indexPath.row)
            return cell
            
        case .category(viewModel: let viewModel):
            guard let cell = recipeTableView.dequeueReusableCell(
                withIdentifier: CategoryCollectionTableViewCell.identifier,
                for: indexPath
            ) as? CategoryCollectionTableViewCell else {
                return UITableViewCell()
            }
            cell.backgroundColor = .black
  //          cell.configure(with: viewModel, indexPath: indexPath.row)
           return cell
            
        case .description(viewModel: let viewModel):
            guard let cell = recipeTableView.dequeueReusableCell(
                withIdentifier: RecipeDescriptionTableViewCell.identifier,
                for: indexPath
            ) as? RecipeDescriptionTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: viewModel, indexPath: indexPath.row)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}





