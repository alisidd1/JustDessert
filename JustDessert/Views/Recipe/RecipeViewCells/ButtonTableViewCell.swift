//
//  ButtonTableViewCell.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 3/18/21.
//

import UIKit

protocol ButtonTableViewCellDelegate: AnyObject {
    func buttonTableViewCellDidTapButton(_ cell: ButtonTableViewCell, viewModel: ButtonViewModel)
}

class ButtonTableViewCell: UITableViewCell {
    static let identifier = "ButtonTableViewCell"
    weak var delegate: ButtonTableViewCellDelegate?
    private var viewModel: ButtonViewModel?
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        button.addTarget(self, action: #selector(didTapBtn), for: .touchUpInside)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = CGRect(x: 22, y: 0, width: contentView.width-44, height: contentView.height)
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with viewModel: ButtonViewModel) {
        button.backgroundColor = viewModel.buttonColor
        button.setTitleColor(.label, for: .normal)
        button.setTitle(viewModel.buttonTitle, for: .normal)
        self.viewModel = viewModel
    }
    
    // ButtonTableViewCellDelegate
    @objc func didTapBtn() {                
        guard let viewModel = self.viewModel else {
            return
        }
        delegate?.buttonTableViewCellDidTapButton(self, viewModel: viewModel)
    }
}

