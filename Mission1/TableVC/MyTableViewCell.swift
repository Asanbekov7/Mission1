//
//  MyTableViewCell.swift
//  Mission1
//
//  Created by Темирлан Асанбеков on 5/7/23.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func datePickerAction(_ sender: UIDatePicker) {
    }
    
    func refresh(_ model: ModelTVC) {
        titleLabel.text = model.titleLabel
        detailLabel.text = model.detailLabel
        datePicker.date = model.datePicker
    }
}
