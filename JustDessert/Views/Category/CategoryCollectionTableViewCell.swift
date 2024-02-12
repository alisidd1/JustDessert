//
//  CategoryCollectionTableViewCell.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 3/26/21.
//

import Foundation
import UIKit

class CategoryCollectionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    weak var delegate: CategoryCollectionTableViewCellDelegte?

    static let identifier = "CategoryCollectionTableViewCell"

    private var viewModels: [CategoryCollectionViewCellViewModel] = []
    
    private let collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.sectionInset = UIEdgeInsets(top: 1, left: 10, bottom: 1, right: 10)
        viewLayout.scrollDirection = .horizontal
        viewLayout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionTableViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemRed
        contentView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewModel = viewModels[indexPath.row]
        delegate?.didTapCategoryCollectionItem(viewModel: viewModel)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewModel = viewModels[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryCollectionTableViewCell.identifier,
                for: indexPath
        ) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(viewModel: viewModel)
        return cell
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    func configure(with viewModel: CategoryTableViewCellViewModel ) {
        self.viewModels = viewModel.viewModels
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: contentView.width/2, height: contentView.height/1.5)
    }
}
