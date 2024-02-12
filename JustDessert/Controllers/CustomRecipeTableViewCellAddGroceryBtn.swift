//
//  CustomRecipeTableViewCellAddGroceryBtn.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 3/18/21.
//

import UIKit

class CustomRecipeTableViewCellAddGroceryBtn: UITableViewCell {

        let addGroceryBtn: UIButton = {
            let addGroceryBtn = UIButton()
            addGroceryBtn.backgroundColor = .systemBlue
            addGroceryBtn.setTitle("Add To Grocery List", for: .normal)
            addGroceryBtn.setTitleColor(.white, for: .normal)
            return addGroceryBtn
        }()
        
        override func layoutSubviews() {
            super.layoutSubviews()
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
        }
     

        

    //    override func awakeFromNib() {
    //        super.awakeFromNib()
    //        // Initialization code
    //    }
    //
    //    override func setSelected(_ selected: Bool, animated: Bool) {
    //        super.setSelected(selected, animated: animated)

    //       // Configure the view for the selected state
    //    }

    


}
