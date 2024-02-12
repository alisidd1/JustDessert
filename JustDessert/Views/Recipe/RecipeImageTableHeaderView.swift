//
//  TableHeaderView.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 3/23/21.
//

import Foundation
import UIKit

class RecipeTableHeaderView: UIView {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    
    func configure(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data else {
                return
            }
            DispatchQueue.main.async {
                self?.imageView.image = UIImage(data: data)
            }
        }
        task.resume()
    }
    

}
