//
//  Model.swift
//  Mission1
//
//  Created by Темирлан Асанбеков on 5/7/23.
//

import Foundation
import UIKit

struct ModelCellTVC: Codable {
    let titleLabel: String
    let editLabel: String
    let datePicker: Date
    
    
    
    static func makeCells() -> [ModelCellTVC] {
        var tempArray: [ModelCellTVC] = []
        
        UserDefaults.standard.dictionaryRepresentation().forEach { (key: String, value: Any) in
            guard let data = value as? Data else { return }
            do {
                let decoder = JSONDecoder()
                let model = try decoder.decode(ModelCellTVC.self, from: data)
                tempArray.append(model)
            } catch {
                print("Error")
            }
        }
        return tempArray
    }
    
}