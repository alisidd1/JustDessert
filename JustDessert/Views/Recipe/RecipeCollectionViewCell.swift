//
//  RecipeCollectionViewCell.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 4/22/21.
//

import Foundation
import UIKit

final class RecipeCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecipeCollectionViewCell"
       
    private let nameLabel:  UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.sizeToFit()
        return nameLabel
    }()
  
    private let ImageView: UIImageView = {
        let ImageView = UIImageView()
        ImageView.contentMode = .scaleAspectFit
        ImageView.clipsToBounds = true
        return ImageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(nameLabel)
        contentView.addSubview(ImageView)
        contentView.backgroundColor = .systemBackground
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.frame = CGRect(x: 10, y: (contentView.frame.height/4)*3+5, width: contentView.frame.width-20, height: 30)
        nameLabel.numberOfLines = 2
        nameLabel.sizeToFit()
        
        ImageView.frame = CGRect(x: 20, y: 10, width: contentView.frame.width-60, height: (contentView.frame.height - 60))
        ImageView.layer.cornerRadius = ImageView.frame.height / 2
        ImageView.contentMode = UIView.ContentMode.scaleAspectFill

        ImageView.clipsToBounds = true
        ImageView.layer.borderWidth = 1.0
        ImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    public func configure(with viewModel: RecipeCollectionViewCellViewModel) {
        nameLabel.text = viewModel.name
        getRecipeImage(with: viewModel)
        guard let data = viewModel.imageData else {
            return
        }
        ImageView.image = UIImage(data: data)
      }
    
    func getRecipeImage(with viewModel: RecipeCollectionViewCellViewModel) {
        // Image
        if let imageData = viewModel.imageData {
            ImageView.image = UIImage(data: imageData)
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
                    self?.ImageView.image = UIImage(data: imageData)
                }
            }
            imageTask.resume()
        }
    }
}

