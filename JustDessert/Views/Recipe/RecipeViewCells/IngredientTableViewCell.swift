//
//  IngredientTableViewCell.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 3/22/21.
//

import Foundation
import UIKit

class IngredientTableViewCell: UITableViewCell {
    static let identifier = "IngredientTableViewCell"
    
    private let ingredientLabel:  UILabel = {
        let ingredientLabel = UILabel()
        ingredientLabel.font = UIFont(name: "Arial", size: 20)
        ingredientLabel.translatesAutoresizingMaskIntoConstraints = false
        ingredientLabel.textColor = .label
        ingredientLabel.numberOfLines = 0
        return ingredientLabel
    }()
    
    private let numberImageView: UIImageView = {
        let numberImageView = UIImageView()
        numberImageView.contentMode = .scaleAspectFit
        numberImageView.clipsToBounds = true
        return numberImageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(ingredientLabel)
        contentView.addSubview(numberImageView)
        NSLayoutConstraint.activate([
            ingredientLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            ingredientLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            ingredientLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 44),
            ingredientLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -44)
        ])
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        ingredientLabel.frame = contentView.convert(CGRect(x: contentView.height, y: 0, width: contentView.width-50, height: contentView.height), from: contentView)
        numberImageView.frame = CGRect(
            x: 10,
            y: (contentView.height-24)/2,
            width: 24,
            height: 24
        )
    }
    
    func configure(with viewModel: IngredientViewModel) {
        ingredientLabel.text = viewModel.ingredient
        let imageName = "\(viewModel.number).circle.fill"
        let image = UIImage(
            systemName: imageName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
        )
        numberImageView.tintColor = .green
        numberImageView.image = image
    }
}


