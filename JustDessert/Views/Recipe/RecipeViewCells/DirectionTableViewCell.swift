//
//  DirectionViewModel.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 3/22/21.
//

import Foundation
import UIKit

class DirectionViewModel: UITableViewCell {
    static let identifier = "DirectionViewModel"
    
    private let DirectionLabel:  UILabel = {
        let DirectionLabel = UILabel()
        DirectionLabel.textColor = .label
        DirectionLabel.font = UIFont(name: "Arial", size: 20)
        DirectionLabel.translatesAutoresizingMaskIntoConstraints = false
        DirectionLabel.numberOfLines = 0
        return DirectionLabel
    }()
    
    private let numberImageView: UIImageView = {
        let numberImageView = UIImageView()
        return numberImageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(DirectionLabel)
        contentView.addSubview(numberImageView)
        
        NSLayoutConstraint.activate([
            DirectionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            DirectionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            DirectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 44),
            DirectionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -44)
        ])
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DirectionLabel.frame = CGRect(
            x: contentView.height,
            y: 0,
            width: contentView.width-50,
            height: contentView.height)
        numberImageView.frame = CGRect(
            x: 10,
            y: (contentView.height-24)/2,
            width: 24,
            height: 24)
    }
    
    func configure(with viewModel: directionViewModel, indexPath: Int) {
        let imageName = "\(indexPath+1).circle.fill"
        let image = UIImage(
            systemName: imageName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
        )
        DirectionLabel.text = viewModel.direction
        numberImageView.image = image
    }
}

