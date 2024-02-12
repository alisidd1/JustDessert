//
//  CustomTabBarController.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 3/10/21.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController {
    
    let todayVC  = TodayViewController()
    let browseVC = BrowseViewController()
    let searchVC = SearchViewController()
    public let savedVC = SavedViewController()
    let moreVC = MoreViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    func configure() {
        todayVC.title = "Today"
        browseVC.title = "Browse"
        searchVC.title = "Search"
        savedVC.title = "Saved"   // scrollview/nav bar will give title
        moreVC.title = "More"
        
        let nav1 = UINavigationController(rootViewController: todayVC)
        let nav2 = UINavigationController(rootViewController: browseVC)
        let nav3 = UINavigationController(rootViewController: searchVC)
        let nav4 = UINavigationController(rootViewController: savedVC)
        let nav5 = UINavigationController(rootViewController: moreVC)
        
        nav1.tabBarItem = UITabBarItem(title: "Today", image: UIImage(systemName: "calendar"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Browse", image: UIImage(systemName: "sparkles"), tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        nav4.tabBarItem = UITabBarItem(title: "Saved", image: UIImage(systemName: "bookmark"), tag: 1)
        nav5.tabBarItem = UITabBarItem(title: "More", image: UIImage(systemName: "line.horizontal.3"), tag: 1)

        setViewControllers(
            [nav1, nav2, nav3, nav4, nav5
            ], animated: true)
    }
}


