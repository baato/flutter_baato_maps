//
//  Font.swift
//  BaatoApp
//
//  Created by Mohan Singh Thagunna on 14/02/2024.
//  Copyright © 2024 Bhawak Pokhrel. All rights reserved.
//


import SwiftUI

extension UIFont {
    static func roboto(weight: RobotoFontStyle = .regular, size: CGFloat = 16) -> UIFont {
        return UIFont(name: weight.rawValue, size: size) ?? .systemFont(ofSize: size)
    }
}
extension Font {
    static func roboto(weight: RobotoFontStyle = .regular, size: CGFloat = 16) -> Font {
        return .custom(weight.rawValue, size: size)
    }
}

enum RobotoFontStyle: String {
    case black = "Roboto-Black",
         blackItalic = "Roboto-BlackItalic",
         bold = "Roboto-Bold",
         boldItalic = "Roboto-BoldItalic",
         italic = "Roboto-Italic",
         light = "Roboto-Light",
         lightItalic = "Roboto-LightItalic",
         medium = "Roboto-Medium",
         mediumItalic = "Roboto-MediumItalic",
         regular = "Roboto-Regular",
         thin = "Roboto-Thin",
         thinItalic = "Roboto-ThinItalic"
}
