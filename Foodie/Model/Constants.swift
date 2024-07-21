//
//  Constants.swift
//  Foodie
//
//  Created by Luis Calvillo on 7/18/24.
//

import UIKit

extension UIColor {
    static let theme = ColorTheme()
}

struct ColorTheme {
    
    let accent = UIColor(named: "AccentColor")
}

enum SFSymbols {
    static let directions = UIImage(systemName: "car")
    static let phone = UIImage(systemName: "phone")
    static let website = UIImage(systemName: "safari")
    static let annotation = UIImage(systemName: "fork.knife")
}
