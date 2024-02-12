//
//  ButtonViewModel.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 3/24/21.
//

import Foundation
import UIKit

enum ButtonType {
    case favorite
    case grocery
}

struct ButtonViewModel {
    let buttonTitle: String
    let buttonColor: UIColor
    let buttonType: ButtonType
}
