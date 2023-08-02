//
//  Model.swift
//  Mission1
//
//  Created by Темирлан Асанбеков on 5/7/23.
//

import UIKit

struct ModelCellTVC: Codable {
    let titleLabel: String
    let editLabel: String
    var date: String
    let key: String
    let personImage: Data?
    
    var isSelected = false
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
