//
//  RecipeTableViewCell.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 3/10/21.
//

import Foundation
import UIKit

class RecipeTableViewCell: UITableViewCell {
    static let identifier = "RecipeTableViewCell"
    
    private let recipeNameLabel: UILabel = {
        let recipeNameLabel = UILabel()
        recipeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        recipeNameLabel.font = .systemFont(ofSize: 15)
        recipeNameLabel.numberOfLines = 0
        return recipeNameLabel
    }()
    
    private let recipeImageView: UIImageView = {
        let recipeImageView = UIImageView()
        recipeImageView.contentMode = .scaleAspectFill
        recipeImageView.clipsToBounds = true
        recipeImageView.layer.cornerRadius = 8
        recipeImageView.layer.masksToBounds = true
        recipeImageView.translatesAutoresizingMaskIntoConstraints = false
        return recipeImageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(recipeNameLabel)
        contentView.addSubview(recipeImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let imageMargin: CGFloat = 3
        let imageSize: CGFloat = contentView.height-(imageMargin * 2)
        recipeImageView.frame = CGRect(
            x: imageMargin,
            y: imageMargin,
            width: imageSize,
            height: imageSize
        )
       recipeNameLabel.frame = CGRect(
            x: imageSize + (imageMargin * 2),
            y: 0,
            width: contentView.width - imageSize - (imageMargin * 2),
            height: contentView.height)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        recipeNameLabel.text = nil
        recipeImageView.image = nil
    }
    
    /// Configure cell with viewModel
    /// - Parameter viewModel: Object representing data for view to render
    func configure(with viewModel: RecipeCellViewModel) {
        recipeNameLabel.text = viewModel.title
        
        // Image
        if let imageData = viewModel.imageData {
            recipeImageView.image = UIImage(data: imageData)
        }
        else {
            guard let url = URL(string: viewModel.imageURLString) else {
                return
            }
            
            let imageTask = URLSession.shared.dataTask(with: url) { [weak self] (imageData, response, error) in
                guard let imageData = imageData else {
                    return
                }
                viewModel.imageData = imageData
                DispatchQueue.main.async {
                    self?.recipeImageView.image = UIImage(data: imageData)
                }
            }
            imageTask.resume()
        }
    }
}
