//
//  Uikit+Extensions.swift
//  Mission1
//
//  Created by Темирлан Асанбеков on 25/7/23.
//
import UIKit

class UIHelper {
    
    //MARK: HEX Colors
    
    static let editLabelColor = UIColor(hex: "#8E8E93")
    static let backgroundColor = UIColor(hex: "#F9FAFE")
    static let didUnhighlightColor = UIColor(hex: "#C7C7CC")
    static let buttonBackgroundColor = UIColor(hex: "#007AFF")
    
    //MARK: Titles
    
    static let selectButton = "Выбрать"
    static let readyButton = "Готово"
    static let navigationTitle = "Заметки"
    static let placeHolderTitleTV = "Введите название"
    static let placeHolderDetailTV = "SomeText"
    static let alertTitle = "Предупреждение"
    static let alertMessege = "Оба поля заметки не могут быть пустым"
}

//MARK: Extensions - UIColor

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

//MARK: extension AlertController

extension UIViewController {
    func alertController(title: String, messege: String, alert: UIAlertController.Style) {
        let alert = UIAlertController(title: title, message: messege, preferredStyle: alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
}

//MARK: extension UIImage

extension UIImage {
    func addBackgroundCircle(_ color: UIColor?) -> UIImage? {
        let circleDiameter = max(size.width * 2, size.height * 2)
        let circleRadius = circleDiameter * 0.5
        let circleSize = CGSize(width: circleDiameter, height: circleDiameter)
        let circleFrame = CGRect(x: 0, y: 0, width: circleSize.width, height: circleSize.height)
        let imageFrame = CGRect(
            x: circleRadius - (size.width * 0.5),
            y: circleRadius - (size.height * 0.5),
            width: size.width,
            height: size.height
        )
        
        let view = UIView(frame: circleFrame)
        view.backgroundColor = color ?? .systemRed
        view.layer.cornerRadius = circleDiameter * 0.5
        
        UIGraphicsBeginImageContextWithOptions(circleSize, false, UIScreen.main.scale)
        
        let renderer = UIGraphicsImageRenderer(size: circleSize)
        let circleImage = renderer.image { _ in
            view.drawHierarchy(in: circleFrame, afterScreenUpdates: true)
        }
        
        circleImage.draw(in: circleFrame, blendMode: .normal, alpha: 1.0)
        draw(in: imageFrame, blendMode: .normal, alpha: 1.0)
        
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
}
