//
//  Uikit+Extensions.swift
//  Mission1
//
//  Created by Темирлан Асанбеков on 25/7/23.
//
import UIKit

class UIHelper {
    static let editLabelColor = UIColor(hex: "#8E8E93")
    static let backgroundColor = UIColor(hex: "#F9FAFE")
    static let didUnhighlightColor = UIColor(hex: "#C7C7CC")
    
    static let selectButton = "Выбрать"
    static let readyButton = "Готово"
    static let navigationTitle = "Заметки"
    
}


extension UIColor {
    convenience init(hex: String) {
        let hexString = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var intColor: UInt64 = 0
        
        Scanner(string: hexString).scanHexInt64(&intColor)
        
        let r, g, b: UInt64
        switch hexString.count {
        case 3: // Для трехзначного HEX: #RGB
            (r, g, b) = ((intColor >> 8) * 17, (intColor >> 4 & 0xF) * 17, (intColor & 0xF) * 17)
        case 6: // Для шестизначного HEX: #RRGGBB
            (r, g, b) = (intColor >> 16, intColor >> 8 & 0xFF, intColor & 0xFF)
        default:
            (r, g, b) = (0, 0, 0)
        }
        
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: 1.0)
    }
}
