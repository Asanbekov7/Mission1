//
//  Model.swift
//  Mission1
//
//  Created by Темирлан Асанбеков on 5/7/23.
//

import UIKit

struct ModelCellTVC: Codable, Hashable {
    let titleLabel: String
    let editLabel: String
    var date: String
    let key: String
    let personImage: Data?
    
    var isSelected = false
}
