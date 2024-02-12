//
//  BrowseCollectionTableViewCell.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 4/22/21.
//

import Foundation
import UIKit

final class BrowseCollectionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var delegate: BrowseCollectionTableViewCellDelegte?
    
    static let identifier = "BrowseCollectionTableViewCell"
    
    private var viewModels: [RecipeCollectionViewCellViewModel] = []
    
    private let collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        viewLayout.scrollDirection = .horizontal
        viewLayout.minimumInteritemSpacing = 1
        viewLayout.minimumLineSpacing = 1
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: "RecipeCollectionViewCell")
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (contentView.width-3)/2, height: (contentView.width-3)/2)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewModel = viewModels[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "RecipeCollectionViewCell",
            for: indexPath
        ) as? RecipeCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewModel = viewModels[indexPath.row]
        delegate?.didTapRecipeCollectionItem(viewModel: viewModel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = CGRect(x: 0, y: 0, width: contentView.width, height: contentView.height)
    }
    
    func configure(with viewModels: [RecipeCollectionViewCellViewModel] ) {
        self.viewModels = viewModels
        collectionView.reloadData()
    }
}

