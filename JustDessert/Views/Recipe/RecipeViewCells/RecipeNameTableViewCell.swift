//
//  RecipeNameTableViewCell.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 3/26/21.
//

import Foundation
import UIKit

class RecipeNameTableViewCell: UITableViewCell {
    static let identifier = "RecipeNameTableViewCell"
    
    private let recipeNameLabel:  UILabel = {
        let recipeNameLabel = UILabel()
        recipeNameLabel.textColor = .systemBlue
        recipeNameLabel.font = UIFont(name: "Arial", size: 25)
        recipeNameLabel.font = UIFont.boldSystemFont(ofSize: 25)
        recipeNameLabel.numberOfLines = 0
        recipeNameLabel.translatesAutoresizingMaskIntoConstraints = false
       return recipeNameLabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(recipeNameLabel)
        
        NSLayoutConstraint.activate([
            recipeNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            recipeNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            recipeNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 4),
            recipeNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4)
            ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        recipeNameLabel.frame = CGRect(x: 5, y: 0, width: contentView.width, height: contentView.height)
     }
    
    func configure(with viewModel: RecipeNameTableViewCellViewModel, indexPath: Int) {
        recipeNameLabel.text = viewModel.RecipeNameTableViewCellViewModelLabel
        
    }
}


