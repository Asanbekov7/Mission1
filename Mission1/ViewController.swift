//
//  ViewController.swift
//  Mission1
//
//  Created by Темирлан Асанбеков on 30/6/23.
//

import UIKit

class ViewController: UIViewController {
    //MARK: Outlets
    var detailTextView = UITextView() //detailTextView
    var titleTextView = UITextView() //titleTextView
    var changeBtn = UIButton()
    var titleLabel = UILabel()
    var dateLabel = UILabel()
    
    let placeHolderTitleTV = "Заголовок"
    let placeHolderEditTV = "SomeText"
    var isSpaceAdded = false
    
    let colorPlaceHolders: UIColor = .lightGray
    let colorTextSelected: UIColor = .black
    
    //MARK: lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        addCustomSubViews()
        createdAllViewConstraint()
        configKeyBoard()
        getTextViewValues()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configKeyBoard()
    }
    
    func getTextViewValues() {
        if let uDStringValueMiniTV = getValueUserDefaults(key: UserDefaultsKeysValues.editTitleTV.rawValue) as? String {
            titleTextView.text = uDStringValueMiniTV
        }
        
        if let uDStringValueMaxTV = getValueUserDefaults(key: UserDefaultsKeysValues.editDetailTV.rawValue) as? String {
            detailTextView.text = uDStringValueMaxTV
        }
    }
    
    //MARK: Setup Text View, Button, Labels
    func addCustomSubViews() {
        
        let colorTV = UIColor.white
        let borderColor = UIColor.white.cgColor
        
        //setup maxTextView
        detailTextView.translatesAutoresizingMaskIntoConstraints = false
        detailTextView.font = UIFont.systemFont(ofSize: 14)
        detailTextView.layer.cornerRadius = 8.0
        detailTextView.layer.borderWidth = 2.0
        detailTextView.layer.borderColor = borderColor
        
        //setup MiniTextView
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        titleTextView.isScrollEnabled = false
        titleTextView.textContainer.maximumNumberOfLines = 1
        titleTextView.textContainer.lineBreakMode = .byTruncatingTail
        titleTextView.textAlignment = .center
        titleTextView.textContainerInset = .zero
        titleTextView.textContainer.lineFragmentPadding = 0
        titleTextView.font = UIFont.boldSystemFont(ofSize: 22)
        titleTextView.layer.cornerRadius = 8.0
        titleTextView.layer.borderWidth = 2.0
        titleTextView.layer.borderColor = borderColor
        
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
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
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
        self.view.addSubview(detailTextView)
        self.view.addSubview(titleTextView)
        self.view.addSubview(changeBtn)
        self.view.addSubview(titleLabel)
        self.view.addSubview(dateLabel)
        self.detailTextView.delegate = self
        self.titleTextView.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
    }
    //Action by Keyboard
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func configKeyBoard() {
        detailTextView.becomeFirstResponder()
    }
    
    //MARK: NSLayoutConstraints
    func createdAllViewConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -120),
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0),
            titleLabel.bottomAnchor.constraint(equalTo: self.dateLabel.topAnchor, constant: -5),
        ])
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            dateLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30),
            dateLabel.bottomAnchor.constraint(equalTo: self.titleTextView.topAnchor, constant: -5),
        ])
        NSLayoutConstraint.activate([
            titleTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            titleTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            titleTextView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 70),
            titleTextView.bottomAnchor.constraint(equalTo: self.detailTextView.topAnchor, constant: -5),
        ])
        NSLayoutConstraint.activate([
            detailTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 17),
            detailTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -17),
            detailTextView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 110),
            detailTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),
        ])
        NSLayoutConstraint.activate([
            changeBtn.leadingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor, constant: 5),
            changeBtn.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            changeBtn.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0),
            changeBtn.bottomAnchor.constraint(equalTo: self.dateLabel.topAnchor, constant: -5)
        ])
    }
    
    //MARK: User Default
    func setUserDefault(value: Any, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func getValueUserDefaults(key: String) -> Any? {
        return UserDefaults.standard.value(forKey: key)
    }
    
}
//MARK: Extension textView delegate

extension ViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == titleTextView {
            if textView.text == placeHolderTitleTV {
                textView.text = ""
                textView.textColor = colorTextSelected
            }
        } else if !isSpaceAdded {
            textView.text = textView.text + " "
            isSpaceAdded = true
        }
        
        if textView == detailTextView {
            if textView.text == placeHolderEditTV {
                textView.text = ""
                textView.textColor = colorTextSelected
            } else if !isSpaceAdded {
                textView.text = textView.text + " "
                isSpaceAdded = true
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == titleTextView {
            if textView.text == "" {
                textView.text = ""
                textView.textColor = colorTextSelected
            } else if textView.text == placeHolderTitleTV {
                textView.text = ""
                textView.textColor = colorTextSelected
            }
        }
        
        if textView == detailTextView {
            if textView.text == "" {
                textView.text = ""
                textView.textColor = colorTextSelected
            } else if textView.text == placeHolderEditTV {
                textView.text = ""
                textView.textColor = colorTextSelected
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == titleTextView {
            if textView.text == "" || textView.text == placeHolderTitleTV {
                textView.text = placeHolderTitleTV
                textView.textColor = colorPlaceHolders
            } else {
                setUserDefault(value: textView.text as String, key: UserDefaultsKeysValues.editTitleTV.rawValue)
            }
        }
        
        if textView == detailTextView {
            if textView.text == "" || textView.text == placeHolderEditTV {
                textView.text = placeHolderEditTV
                textView.textColor = colorPlaceHolders
            } else {
                let trimmedText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
                setUserDefault(value: trimmedText as String, key: UserDefaultsKeysValues.editDetailTV.rawValue)
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
enum UserDefaultsKeysValues: String {
    case editDetailTV
    case editTitleTV
}
