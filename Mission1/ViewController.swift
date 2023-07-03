//
//  ViewController.swift
//  Mission1
//
//  Created by Темирлан Асанбеков on 30/6/23.
//

import UIKit

class ViewController: UIViewController {
    //MARK: Outlets
    var maxTextView = UITextView()
    var miniTextView = UITextView()
    var changeBtn = UIButton()
    var titleLabel = UILabel()
    var dateLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCustomSubViews()
        createdTextViewConstraint()
        configKeyBoard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.maxTextView.becomeFirstResponder()
    }
    
//MARK: Setup Text View, Button, Labels
    func addCustomSubViews() {
        
        let colorTV = UIColor.white
        let borderColor = UIColor.white.cgColor

        //setup maxTextView
        maxTextView.translatesAutoresizingMaskIntoConstraints = false
        maxTextView.backgroundColor = colorTV
        maxTextView.text = "SomeText"
        maxTextView.textColor = .lightGray
        maxTextView.font = UIFont.systemFont(ofSize: 14)
        maxTextView.layer.cornerRadius = 8.0
        maxTextView.layer.borderWidth = 2.0
        maxTextView.layer.borderColor = borderColor
        
        //setup MiniTextView
        miniTextView.translatesAutoresizingMaskIntoConstraints = false
        miniTextView.backgroundColor = colorTV
        miniTextView.text = "Заголовок"
        miniTextView.font = UIFont.boldSystemFont(ofSize: 14)
        miniTextView.textAlignment = .center
        miniTextView.layer.cornerRadius = 8.0
        miniTextView.layer.borderWidth = 2.0
        miniTextView.layer.borderColor = borderColor
        
        //setup Button
        changeBtn.translatesAutoresizingMaskIntoConstraints = false
        changeBtn.setTitle("Готово", for: .normal)
        changeBtn.setTitleColor(.black, for: .normal)
        changeBtn.backgroundColor = colorTV
        changeBtn.layer.cornerRadius = 8.0
        changeBtn.layer.borderWidth = 2.0
        changeBtn.layer.borderColor = borderColor
        changeBtn.addTarget(self, action: #selector(hideKeyboard), for: .touchUpInside)
        
        //setupTextLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.textColor = .lightGray
        titleLabel.text = "Введите название"
        titleLabel.textAlignment = .left
        titleLabel.backgroundColor = colorTV
        titleLabel.layer.cornerRadius = 8.0
        titleLabel.layer.borderWidth = 2.0
        titleLabel.layer.borderColor = borderColor
        
        //setup dateLabel
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd.MM.yyyy EEEE HH:mm"
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        dateLabel.text = formattedDate
        dateLabel.font = UIFont.systemFont(ofSize: 13)
        dateLabel.textColor = .gray
        dateLabel.textAlignment = .center
        dateLabel.layer.cornerRadius = 8.0
        dateLabel.layer.borderWidth = 2.0
        dateLabel.layer.borderColor = borderColor
        
        //addSubview
        self.view.addSubview(maxTextView)
        self.view.addSubview(miniTextView)
        self.view.addSubview(changeBtn)
        self.view.addSubview(titleLabel)
        self.view.addSubview(dateLabel)
        self.maxTextView.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tapGesture)

    }
    
    @objc func hideKeyboard() {
        maxTextView.resignFirstResponder()
        miniTextView.resignFirstResponder()
    }
    
    
    
    func createdTextViewConstraint() {
        NSLayoutConstraint.activate([
            miniTextView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            miniTextView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -120),
            miniTextView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            miniTextView.bottomAnchor.constraint(equalTo: self.dateLabel.topAnchor, constant: -5),
            miniTextView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            dateLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30),
            dateLabel.bottomAnchor.constraint(equalTo: self.titleLabel.topAnchor, constant: -5),
        ])
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 70),
            titleLabel.bottomAnchor.constraint(equalTo: self.maxTextView.topAnchor, constant: -5),
        ])
        NSLayoutConstraint.activate([
            maxTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 17),
            maxTextView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -17),
            maxTextView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 110),
            maxTextView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20),
            maxTextView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            changeBtn.leadingAnchor.constraint(equalTo: self.miniTextView.trailingAnchor, constant: 5),
            changeBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            changeBtn.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            changeBtn.bottomAnchor.constraint(equalTo: self.dateLabel.topAnchor, constant: -5)
        ])
    }
    
    func configKeyBoard() {
//        maxTextView.becomeFirstResponder() сделал коммит
            }
    
}

extension ViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text == "SomeText" {
            textView.text = ""
            textView.textColor = .black
        }
        return true
    }
}
