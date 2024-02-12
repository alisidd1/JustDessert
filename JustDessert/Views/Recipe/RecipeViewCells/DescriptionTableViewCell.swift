//
//  RecipeDescriptionTableViewCell.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 3/26/21.
//

import Foundation
import UIKit

class RecipeDescriptionTableViewCell: UITableViewCell {
    static let identifier = "RecipeDescriptionTableViewCell"
    
    private let descriptionLabel:  UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 20, weight: .regular)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                constant: 4),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4)
        ])
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        descriptionLabel.frame = CGRect(x: 5, y: 0, width: contentView.width, height: contentView.height)
     }

    func configure(with viewModel: RecipeDescriptionViewModel, indexPath: Int) {
        descriptionLabel.text = viewModel.RecipeDescriptionViewModel
    }
}
