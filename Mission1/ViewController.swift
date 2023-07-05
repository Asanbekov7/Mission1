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
    var dateLabel = UILabel()
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
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
    
    @IBAction func saveButtonAction(_ sender: UIBarButtonItem) {
        view.endEditing(true)
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
        titleTextView.font = UIFont.boldSystemFont(ofSize: 22)
        titleTextView.layer.cornerRadius = 8.0
        titleTextView.layer.borderWidth = 2.0
        titleTextView.layer.borderColor = borderColor
        
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
        self.view.addSubview(dateLabel)
        self.detailTextView.delegate = self
        self.titleTextView.delegate = self
        
    }
  
    func configKeyBoard() {
        detailTextView.becomeFirstResponder()
    }
    
    //MARK: NSLayoutConstraints
    func createdAllViewConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            dateLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30),
            dateLabel.bottomAnchor.constraint(equalTo: self.titleTextView.topAnchor, constant: -5),
        ])
        NSLayoutConstraint.activate([
            titleTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 17),
            titleTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -17),
            titleTextView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 70),
            titleTextView.bottomAnchor.constraint(equalTo: self.detailTextView.topAnchor, constant: -5),
        ])
        NSLayoutConstraint.activate([
            detailTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 17),
            detailTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -17),
            detailTextView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 110),
            detailTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),
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
            if textView.text == "" {
                textView.text = placeHolderTitleTV
                textView.textColor = colorPlaceHolders
            } else {
                setUserDefault(value: textView.text as String, key: UserDefaultsKeysValues.editTitleTV.rawValue)
            }
        }
        
        if textView == detailTextView {
            if textView.text == "" {
                textView.text = placeHolderEditTV
                textView.textColor = colorPlaceHolders
            } else {
                let trimmedText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
                setUserDefault(value: trimmedText as String, key: UserDefaultsKeysValues.editDetailTV.rawValue)
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == titleTextView {
            if text == "\n" {
                textView.resignFirstResponder()
                return false
            }
        }
        return true
    }
}
enum UserDefaultsKeysValues: String {
    case editDetailTV
    case editTitleTV
}
