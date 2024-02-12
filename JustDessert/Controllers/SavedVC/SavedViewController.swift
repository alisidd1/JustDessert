//
//  SavedVewController.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 3/10/21.
//

import Foundation
import UIKit
import RealmSwift
import GoogleMobileAds

class SavedViewController: UIViewController, UIScrollViewDelegate {
    
    // To Do
    // delegate to scroll view so when finger moves the scroll - segments shud be moved
    // notification - observe - did add grocery ist/ fav list - update table view
    // swipe to delete row for both child controller
    
    private let banner: GADBannerView = {
       let banner = GADBannerView()
        banner.backgroundColor =  .secondarySystemBackground
        banner.adUnitID = "ca-app-pub-6335449243315858/7789209461"
        banner.load(GADRequest())
        return banner
    }()

    public var recipes: [Recipe] = []
    private var viewModels: [RecipeCellViewModel] = []
    private lazy var groceryViewController = GroceryViewController()
    private lazy var favoritesViewController = FavoritesViewController()
    
    let savedScrollView: UIScrollView = {
        let savedScrollView = UIScrollView()
        savedScrollView.backgroundColor = .systemOrange
        savedScrollView.isPagingEnabled = true
        savedScrollView.isScrollEnabled = false
        return savedScrollView
    }()
    
    let segmentedControl: UISegmentedControl = {
        let segmentItems = ["Favorites", "Grocery"]
        let segmentedControl = UISegmentedControl(items: segmentItems)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .systemBlue
        return segmentedControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        segmentedControl.addTarget(self, action: #selector(segmentControl), for: .valueChanged)
        view.addSubview(savedScrollView)
        savedScrollView.delegate = self
        navigationItem.titleView = segmentedControl
        addChildViewControllers()
        banner.rootViewController = self
        view.addSubview(banner)
    }
    
    private func addChildViewControllers() {
        addChild(groceryViewController)
        addChild(favoritesViewController)
        groceryViewController.didMove(toParent: self)
        favoritesViewController.didMove(toParent: self)
        savedScrollView.addSubview(groceryViewController.view)
        savedScrollView.addSubview(favoritesViewController.view)
    }
    
    @objc func segmentControl(_ segmentedControl: UISegmentedControl) {
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            savedScrollView.setContentOffset(CGPoint(x: 0, y: 0),
                                             animated: true)
        case 1:
            savedScrollView.setContentOffset(CGPoint(x: view.width, y: 0),
                                             animated: true)
        default:
            break
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        savedScrollView.frame = CGRect(x: 0, // it was view.bounce
                                       y: view.safeAreaInsets.top,
                                       width: view.width,
                                       height: view.height - view.safeAreaInsets.top)
        savedScrollView.contentSize = CGSize(width: view.width * 2, height: 0)
        favoritesViewController.view.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        groceryViewController.view.frame = CGRect(x: view.width, y: 0, width: view.width, height: view.height)
        banner.frame = CGRect(x: 0, y: view.height-130, width: view.width, height: 50).integral
    }
}


