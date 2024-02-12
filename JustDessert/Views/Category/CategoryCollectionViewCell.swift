//
//  CategoryCollectionTableViewCell.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 4/29/21.
//

import Foundation
import UIKit

final class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CategoryCollectionViewCell"
       
    private let categoryNameLabel: UILabel = {
        let categoryNameLabel = UILabel()
        categoryNameLabel.font = .systemFont(ofSize: 20, weight: .medium)
        return categoryNameLabel
    }()

    private let categoryImageView: UIImageView = {
        let categoryImageView = UIImageView()
        categoryImageView.tintColor = .white
        categoryImageView.contentMode = .scaleAspectFit
         return categoryImageView
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(categoryNameLabel)
        contentView.addSubview(categoryImageView)
        contentView.layer.cornerRadius = 6
        contentView.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        categoryNameLabel.frame = CGRect(
            x: 10,
            y: contentView.frame.height - 55,
            width: contentView.frame.width-20,
            height: 50)
        
        let imageSize: CGFloat = contentView.width/2
            
        categoryImageView.frame = CGRect(
            x: contentView.frame.width/2,
            y: 10,
            width: imageSize,
            height: contentView.height/1.2)
    }
    
    func configure(viewModel: CategoryCollectionViewCellViewModel) {
        contentView.backgroundColor = viewModel.color
        categoryNameLabel.text = viewModel.name
        categoryImageView.image = viewModel.image
    }
}

