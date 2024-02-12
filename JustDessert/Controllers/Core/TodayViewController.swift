//
//  TodayViewController.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 3/10/21.
//

import GoogleMobileAds
import Foundation
import UIKit

extension UIView {
    var height: CGFloat {
        return frame.size.height
    }
    var width: CGFloat {
        return frame.size.width
    }
}

class TodayViewController: UIViewController {
    
    // GADBannerViewDelegate, GADInterstitialDelegate
    // https://daddycoding.com/2018/01/08/ios-tutorials-displaying-banner-ads-interstitial-ads-app/
    
    private let banner: GADBannerView = {
       let banner = GADBannerView()
        banner.backgroundColor =  .secondarySystemBackground
        banner.adUnitID = "ca-app-pub-6335449243315858/7789209461"
        banner.load(GADRequest())
        return banner
    }()
    
    private var recipeViewController: RecipeViewController?
    let userDefaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        showActivityIndicator()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let dateString = dateFormatter.string(from: Date())
        
        if let id = UserDefaults.standard.string(forKey: dateString) {
            APICaller.shared.getRecipes { [weak self] (recipes) in
                DispatchQueue.main.async {
                    guard let random = recipes.first(where: {
                        $0.id == id
                    }) else {
                        return
                    }
                    self?.presentRecipeViewController(recipe: random)
                }
            }
        } else { // first time here - no recipe/date neither any recipe info saved
            APICaller.shared.getRecipes { [weak self] (recipes) in
                DispatchQueue.main.async {
                    guard let random = recipes.randomElement() else {
                        return
                    }
                    // save first-time recipe
                    UserDefaults.standard.setValue(random.id, forKey: dateString)
                    self?.presentRecipeViewController(recipe: random)
                }
            }
        }
    }
    
    func presentRecipeViewController (recipe: Recipe) {
        let vc = RecipeViewController(recipe: recipe)
        self.addChild(vc)
        self.view.addSubview(vc.view)
        vc.view.frame = self.view.bounds
        vc.didMove(toParent: self)
        self.recipeViewController = vc
        banner.rootViewController = self
        view.addSubview(banner)
    }
    
    func showActivityIndicator() {
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        activityView.startAnimating()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        recipeViewController?.view.frame = view.bounds
        banner.frame = CGRect(x: 0, y: view.height-130, width: view.width, height: 50).integral
    }
}
