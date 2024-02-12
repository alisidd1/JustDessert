//
//  BrowseViewController.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 3/10/21.
//

import Foundation
import UIKit
import AVKit
import AVFoundation
import GoogleMobileAds

class BrowseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, BrowseCollectionTableViewCellDelegte, CategoryCollectionTableViewCellDelegte
{    
    let hederHeight: CGFloat = 61
    var playerLooper: AVPlayerLooper!
    private var sections: [BrowseSectionsType] = []
    private var allCategories = [Category]()
    private var selectedCategory: Category?
    
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
        tableView.register(BrowseCollectionTableViewCell.self,
                           forCellReuseIdentifier: BrowseCollectionTableViewCell.identifier)
        tableView.register(CategoryCollectionTableViewCell.self,
                            forCellReuseIdentifier: CategoryCollectionTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        configureHeader()
        fetchData()
        
        let allCategorie = UIBarButtonItem(title: "All Categories", style: .plain, target: self, action: #selector(onSearchButtonClicked))
        navigationItem.rightBarButtonItems = [allCategorie]
        
        banner.rootViewController = self
        view.addSubview(banner)
    }
    
    @objc func onSearchButtonClicked(_ sender: Any){
         presentAllCategoriesViewController ()
    }
    
    private func presentAllCategoriesViewController () {
        let vc = AllCategoriesViewController(categories: allCategories)
        vc.title = "Categories"
        vc.completion = { [weak self] category in
            DispatchQueue.main.async {
                self?.sections.removeAll()
                self?.tableView.reloadData()
                self?.selectedCategory = category
                
                APICaller.shared.getRecipes { (recipes) in
                    let filtered = recipes.filter({
                        $0.category.lowercased() == category.name.lowercased()
                    })
                    self?.configureSections(recipes: filtered)
                }
                
            }
        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        banner.frame = CGRect(x: 0, y: view.height-130, width: view.width, height: 50).integral
    }
    
    func fetchData() {
        APICaller.shared.getRecipes { [weak self] recipes in
            DispatchQueue.main.async {
                
                self?.configureSections(recipes: recipes)
            }
        }
    }
    
    private func configureSections(recipes: [Recipe]) {
        let random = recipes[randomPick: selectedCategory == nil ? 10 : 15]
        sections.append(
            .forYou(
                viewModel:
                    ForYouRecipeCollectionViewCellViewModel(
                        viewModels: random.compactMap(
                            { model in
                                RecipeCollectionViewCellViewModel(
                                    name: model.name,
                                    imageURLString: model.image,
                                    imageData: nil
                                )
                            }
                        )
                    )
            )
        )
        
        guard selectedCategory == nil else {
            sections.append(.favoriteCakes(viewModels: recipes.compactMap({
                RecipeCellViewModel(title: $0.name,
                                    imageURLString: $0.image,
                                    imageData: nil)
            })))
            
            tableView.reloadData()
            return
        }
        
        let colors = [UIColor.systemPink, UIColor.systemBlue, UIColor.systemRed, UIColor.systemGreen]
        // Model
        let categories: [Category] = recipes.compactMap({
            Category(name: $0.category)
        })
        let allCategories = Array(Set(categories))
        
        self.allCategories = allCategories
        
        // viewModel
        let categoryViewModel = CategoryTableViewCellViewModel(
            viewModels: allCategories.compactMap({
                CategoryCollectionViewCellViewModel(
                    name: $0.name,
                    image: UIImage(systemName: "airplane"),
                    color: colors.randomElement() ?? .systemPink)
            })
        )
        sections.append(  // needs an array CategoriesCollectionViewCellViewModel
            .category(viewModel: categoryViewModel)
        )
        

        let cakeViewModels = recipes.filter({
            $0.category == "cake"
        })
        .prefix(5)
        .compactMap({
            RecipeCellViewModel(title: $0.name,
                                imageURLString: $0.image,
                                imageData: nil)
        })
        sections.append(
            .favoriteCakes(viewModels: cakeViewModels)
        )
        
        sections.append(
            .beHealthy(
                viewModel:
                    BeHealthyRecipeCollectionViewCellViewModel(
                        viewModels: recipes.filter({
                            $0.category == "healthy"
                        })
                        .prefix(10)
                        .compactMap({ model in
                            RecipeCollectionViewCellViewModel(name:
                                                              model.name,
                                                              imageURLString: model.image,
                                                              imageData: nil)
                        })
                    )
            )
        )
        
        let chocolateAddicts = recipes.filter({
            $0.category == "chocolate"
        })
        .prefix(5)
        .compactMap({
            RecipeCellViewModel(title: $0.name,
                                imageURLString: $0.image,
                                imageData: nil)
        })
        sections.append(.chocolateAddicts(viewModels: chocolateAddicts))
        
        let cookieTime = recipes.filter({
            $0.category == "cookies"
        }).prefix(5).compactMap({
            RecipeCellViewModel(title: $0.name,
                                imageURLString: $0.image,
                                imageData: nil)
        })
        sections.append(.cookieTime(viewModels: cookieTime))
        
        sections.append(
            .pieTime(
                viewModel:
                    PieTimeRecipeCollectionViewCellViewModel(
                        viewModels: recipes.filter({
                            $0.category == "pie"
                        })
                        .prefix(10)
                        .compactMap({ model in
                            RecipeCollectionViewCellViewModel(name: model.name, imageURLString: model.image, imageData: nil)
                        })
                    )
            )
        )
        
        sections.append(
            .trendingFruit(
                viewModel:
                    TrendingFruitRecipeCollectionViewCellViewModel(
                        viewModels: recipes.filter({
                            $0.category == "fruit"
                        })
                        .prefix(10)
                        .compactMap({ model in
                            RecipeCollectionViewCellViewModel(name: model.name, imageURLString: model.image, imageData: nil)
                        })
                    )
            )
        )
        tableView.reloadData()
    }
}

// MARK: - Table View

extension BrowseViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = sections[section]
        switch sectionType {
        
        case .forYou:
            return 1
        case .category:
            return 1
        case .beHealthy:
            return 1
        case .pieTime:
            return 1
        case .trendingFruit:
            return 1
        case .favoriteCakes(viewModels: let viewModels):
            return viewModels.count
        case .chocolateAddicts(viewModels: let viewModels):
            return viewModels.count
        case .cookieTime(viewModels: let viewModels):
            return viewModels.count
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.textColor = .label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return hederHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = sections[indexPath.section]
         
        switch sectionType {
        case .forYou(let forYouRecipeCollectionViewCellViewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: BrowseCollectionTableViewCell.identifier,
                for: indexPath
            ) as? BrowseCollectionTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.configure(with: forYouRecipeCollectionViewCellViewModel.viewModels)
            return cell
            
            
        case .category(let viewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CategoryCollectionTableViewCell.identifier,
                for: indexPath
            ) as? CategoryCollectionTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.configure(with: viewModel)
            return cell
            
        case .beHealthy(let beHealthyRecipeCollectionViewCellViewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: BrowseCollectionTableViewCell.identifier,
                for: indexPath
            ) as? BrowseCollectionTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.configure(with: beHealthyRecipeCollectionViewCellViewModel.viewModels)
            return cell
                    
        case .pieTime(let pieTimeRecipeCollectionViewCellViewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: BrowseCollectionTableViewCell.identifier,
                for: indexPath
            ) as? BrowseCollectionTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.configure(with: pieTimeRecipeCollectionViewCellViewModel.viewModels)
            return cell
            
        case .trendingFruit(let trendingFruitRecipeCollectionViewCellViewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: BrowseCollectionTableViewCell.identifier,
                for: indexPath
            ) as? BrowseCollectionTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.configure(with: trendingFruitRecipeCollectionViewCellViewModel.viewModels)
            return cell
                    
        case .favoriteCakes(let viewModels):
            let viewModel = viewModels[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: RecipeTableViewCell.identifier,
                for: indexPath
            ) as? RecipeTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: viewModel)
            return cell
            
        case .chocolateAddicts(viewModels: let viewModels):
            let viewModel = viewModels[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: RecipeTableViewCell.identifier,
                for: indexPath
            ) as? RecipeTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: viewModel)
            return cell
            
        case .cookieTime(viewModels: let viewModels):
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
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionType = sections[indexPath.section]
        
        switch sectionType {
        case .forYou, .beHealthy:
            return selectedCategory == nil ? view.width : view.width * 1.5
        case .category:
            return ((view.width)*2)/6
        case .pieTime, .trendingFruit:
            return view.width / 2
        case .favoriteCakes, .chocolateAddicts, .cookieTime:
            return 44
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       
        if selectedCategory != nil {
            return section == 0 ? "Recommended" : selectedCategory?.name.uppercased()
        }
        
        let sectionType = sections[section]
        return sectionType.title
    }
    
    func tableView(_ tableview: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
        var recipe: [Recipe]
        if selectedCategory == nil {
            switch indexPath.section {
            case 2:
                recipe = APICaller.shared.recipes.filter({
                    $0.category == "cake"
                })
            case 4:
                recipe = APICaller.shared.recipes.filter({
                    $0.category == "chocolate"
                })
            case 5:
                recipe = APICaller.shared.recipes.filter({
                    $0.category == "cookies"
                })
            default:
                return
            }
            
        } else {
            recipe = APICaller.shared.recipes.filter({
                $0.category == selectedCategory?.name
            })
            
        }
        
        let recipeViewController = RecipeViewController(recipe: recipe[indexPath.row])
        navigationController?.pushViewController(recipeViewController, animated: true)
        recipeViewController.title = recipe[indexPath.row].name
    }
        
    private func configureHeader() {
        let frame = CGRect(x: 0, y: 0, width: view.width, height: 300)
        let headerView: UIView = UIView.init(frame: frame)
        headerView.backgroundColor = .systemBlue
        self.tableView.tableHeaderView = headerView
        
        let asset = AVAsset(url: URL(fileURLWithPath: Bundle.main.path(forResource: "3-IngredientDesserts", ofType: "mp4")!))
        let item = AVPlayerItem(asset: asset)
        let player = AVQueuePlayer(playerItem: item)
        self.playerLooper = AVPlayerLooper(player: player, templateItem: item)
        
        let layer = AVPlayerLayer(player: player)
        layer.frame = CGRect(x: 0, y: 0, width: view.width, height: 300)
        layer.videoGravity = .resizeAspectFill
        headerView.layer.addSublayer(layer)
        player.isMuted = true
        layer.player?.play()
    }
    
    func didTapRecipeCollectionItem(viewModel: RecipeCollectionViewCellViewModel) {
        APICaller.shared.getRecipes { [weak self] recipes in
            DispatchQueue.main.async {
                self?.presentCollectionCellRecipe(viewModel: viewModel,  recipes: recipes)
            }
        }
    }
      
    func didTapCategoryCollectionItem(viewModel: CategoryCollectionViewCellViewModel)  {
        APICaller.shared.getRecipes { [weak self] recipes in
   
            DispatchQueue.main.async {
                self?.presentCategoriesViewController(viewModel: viewModel)

            }
        }
    }
    
    private func presentCategoriesViewController (viewModel: CategoryCollectionViewCellViewModel) {
        let categoryVC = CategoriesViewController(viewModel: viewModel)
        navigationController?.pushViewController(categoryVC, animated: true)
    }



    private func presentCollectionCellRecipe(viewModel: RecipeCollectionViewCellViewModel,
                                             recipes: [Recipe])  {
        let recipe = recipes.filter({
            $0.name == viewModel.name
        })
        let recipeViewController = RecipeViewController(recipe: recipe[0])
        navigationController?.pushViewController(recipeViewController, animated: true)
        recipeViewController.title = recipe[0].name
    }
}

extension Array {
    subscript (randomPick n: Int) -> [Element] {
        var copy = self
        for i in stride(from: count - 1, to: count - n - 1, by: -1) {
            copy.swapAt(i, Int(arc4random_uniform(UInt32(i + 1))))
        }
        return Array(copy.suffix(n))
    }
}




