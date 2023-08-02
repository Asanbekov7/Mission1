//
//  MyTableViewCell.swift
//  Mission1
//
//  Created by Темирлан Асанбеков on 5/7/23.
//

import UIKit
protocol NoteTableViewCellDelegate: AnyObject {
    func cellDidSelect(_ cell: NoteTableViewCell)
}

class NoteTableViewCell: UITableViewCell {
    //MARK: UIProperties
    let viewContent = UIView()
    let titleLabel = UILabel()
    let editLabel = UILabel()
    let dateLabel = UILabel()
    let image = UIImageView()
    let selectionImageView = UIImageView()
    
    //MARK: Init:
    override init(style: UITableViewCell.CellStyle, reuseIdentifier reusIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reusIdentifier)
        setupCell()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: PublicProperties
    func configure(_ cell: NoteTableViewCell, model: ModelCellTVC) {
        titleLabel.text = model.titleLabel
        editLabel.text = model.editLabel
        editLabel.textColor = UIHelper.editLabelColor
        editLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        
       
        
        
        dateLabel.text = model.date
        dateLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        
        titleLabel.layoutMargins = contentView.layoutMargins
        dateLabel.layoutMargins = contentView.layoutMargins
        viewContent.layer.cornerRadius = 8
        viewContent.clipsToBounds = true
        viewContent.layer.masksToBounds = true
        contentView.backgroundColor = .lightGray
        viewContent.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        contentView.layer.masksToBounds = true
        clipsToBounds = true
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIHelper.backgroundColor
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        cell.backgroundColor = .clear
        guard let personImage = model.personImage else { return }
        image.image = UIImage(data: personImage)
    }
    //MARK: PrivateProperties
    private func setupCell() {
        viewContent.addSubview(titleLabel)
        viewContent.addSubview(dateLabel)
        viewContent.addSubview(editLabel)
        viewContent.addSubview(image)
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(viewContent)

        NSLayoutConstraint.activate([
            viewContent.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            viewContent.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            viewContent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            viewContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        [titleLabel, editLabel, dateLabel, image].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            viewContent.addSubview($0)
        }
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            editLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -5),
            editLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            editLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            editLabel.heightAnchor.constraint(equalToConstant: 20),
            
            dateLabel.topAnchor.constraint(equalTo: editLabel.bottomAnchor, constant: 20),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            image.widthAnchor.constraint(equalToConstant: 25),
            image.heightAnchor.constraint(equalToConstant: 25),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}

