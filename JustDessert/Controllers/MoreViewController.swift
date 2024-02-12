//
//  moreViewController.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 4/3/21.
//

import Foundation
import UIKit
import StoreKit
import WebKit
import SafariServices

class MoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        //// add custom cell if needed
        tableView.register(RecipeTableViewCell.self,
                           forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .systemGray
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let recipeTable = tableView
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(recipeTable)
    }
    
    
    // MARK: - Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        switch indexPath.row {
        case 0: cell.textLabel?.text = "Rate App"
        case 1: cell.textLabel?.text = "Share App"
        case 2: cell.textLabel?.text = "Feedback / Help"
        case 3: cell.textLabel?.text = "Privacy"
        case 4: cell.textLabel?.text = "Terms of Use"
        default:
            cell.textLabel?.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableview: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0: rateApp()
        case 1: shareApp()
        case 2: feedback()
        case 3: privacy()
        case 4: termOfUse()
        default:
            return
        }
        
    }
    
    func rateApp() {
//            SKStoreReviewController.requestReview(in: UIWindowScene)
            //requestReview()
            
        if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "appId") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func shareApp()  {
        if let urlStr = NSURL(string: "https://itunes.apple.com/us/app/myapp/idxxxxxxxx?ls=1&mt=8") {
            let objectsToShare = [urlStr]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            if let popup = activityVC.popoverPresentationController {
                popup.sourceView = self.view
                popup.sourceRect = CGRect(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 4, width: 0, height: 0)
            }
            
            self.present(activityVC, animated: true, completion: nil)
        } else {
            // show alert if not available
        }
    }
    
    func feedback() {
        guard let url = URL(string: "https://www.asndigital.com/contact/") else { return }
        let viewController = SFSafariViewController(url: url)
        present(viewController, animated: true, completion: nil)
    }
    
    func privacy() {
        guard let url = URL(string: "https://www.asndigital.com/privacy/") else { return }
        let viewController = SFSafariViewController(url: url)
        present(viewController, animated: true, completion: nil)
    }
    
    func termOfUse() {
        guard let url = URL(string: "https://www.asndigital.com/terms/") else { return }
        let viewController = SFSafariViewController(url: url)
        present(viewController, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}
