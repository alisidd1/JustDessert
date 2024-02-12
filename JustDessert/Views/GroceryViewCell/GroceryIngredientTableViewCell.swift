//
//  GroceryIngredientTableViewCell.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 4/14/21.
//

import Foundation
import UIKit

final class GroceryIngredientTableViewCell: UITableViewCell {
    static let identifier = "GroceryIngredientTableViewCell"
    
    private let label:  UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 20, y: 0, width: contentView.width, height: contentView.height/2)
    }
    
    func configure(with viewModel: IngredientViewModel) {
        label.text = viewModel.ingredient
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
}

