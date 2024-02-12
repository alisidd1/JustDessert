//
//  MoreViewControllerTableViewCell.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 4/8/21.
//

import Foundation
import UIKit

class MoreViewControllerTableViewCell: UITableViewCell {
    static let identifier = "MoreViewControllerTableViewCell"
    
    private let itemLabel: UILabel = {
        let itemLabel = UILabel()
        itemLabel.translatesAutoresizingMaskIntoConstraints = false
        itemLabel.font = .systemFont(ofSize: 15)
        itemLabel.numberOfLines = 0
        return itemLabel
    }()
    
    private let itemImageView: UIImageView = {
        let itemImageView = UIImageView()
        itemImageView.contentMode = .scaleAspectFill
        itemImageView.clipsToBounds = true
        itemImageView.layer.cornerRadius = 8
        itemImageView.layer.masksToBounds = true
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        return itemImageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(itemLabel)
        contentView.addSubview(itemImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageMargin: CGFloat = 3
        let imageSize: CGFloat = contentView.height-(imageMargin * 2)
        itemImageView.frame = CGRect(
            x: imageMargin,
            y: imageMargin,
            width: imageSize,
            height: imageSize
        )
        itemLabel.frame = CGRect(
            x: imageSize + (imageMargin * 2),
            y: 0,
            width: contentView.width - imageSize - (imageMargin * 2),
            height: contentView.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemLabel.text = nil
        itemImageView.image = nil
    }
    
    /// Configure cell with viewModel
    /// - Parameter viewModel: Object representing data for view to render
    func configure(with viewModel: RecipeCellViewModel) {
        itemLabel.text = viewModel.title
        
        // Image
        self.itemImageView.image = UIImage(named: "cake")
    }
}

