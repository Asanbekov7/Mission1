//
//  MyTableViewCell.swift
//  Mission1
//
//  Created by Темирлан Асанбеков on 5/7/23.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    
    let viewContent = UIView()
    let titleLabel = UILabel()
    let editLabel = UILabel()
    let dateLabel = UILabel()
    let color = UIColor(hex: "#F9FAFE")
    
    let datePicker = UIDatePicker()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier reusIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reusIdentifier)
        setupCell()
        configUIElements()
        
    }
    
    func configUIElements() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels

    }

    private func setupCell() {
        contentView.addSubview(viewContent)
        viewContent.addSubview(titleLabel)
//        viewContent.addSubview(datePicker)
        viewContent.addSubview(dateLabel)
        viewContent.addSubview(editLabel)
        
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                viewContent.topAnchor.constraint(equalTo: contentView.topAnchor),
                viewContent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                viewContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                viewContent.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        [titleLabel, editLabel, dateLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            viewContent.addSubview($0)
        }
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: viewContent.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: viewContent.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: viewContent.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            editLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -5),
            editLabel.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor, constant: 10),
            editLabel.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor, constant: -10),
            editLabel.heightAnchor.constraint(equalToConstant: 20),
            
            dateLabel.topAnchor.constraint(equalTo: editLabel.bottomAnchor, constant: 20),
            dateLabel.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor, constant: -10),
            dateLabel.heightAnchor.constraint(equalToConstant: 30),
            
            dateLabel.bottomAnchor.constraint(equalTo: viewContent.bottomAnchor, constant: -10)
        ])
    }
 
    func configure(_ cell: MyTableViewCell, model: ModelCellTVC) {
        titleLabel.text = model.titleLabel
        editLabel.text = model.editLabel
       
        datePicker.date = model.datePicker
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 23)

        titleLabel.layoutMargins = contentView.layoutMargins
        dateLabel.layoutMargins = contentView.layoutMargins
        viewContent.layer.cornerRadius = 8
        viewContent.layer.masksToBounds = true
        cell.contentView.layer.cornerRadius = 8
        cell.contentView.layer.masksToBounds = true
        cell.contentView.backgroundColor = .white
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        cell.backgroundColor = color
        cell.contentView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
       
    }
    
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

