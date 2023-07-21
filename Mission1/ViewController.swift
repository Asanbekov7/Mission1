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
    var datePicker: UIDatePicker!
    let dateFormatter = DateFormatter()
    var saveButton = UIButton()
    var note: ModelCellTVC?
    
    let placeHolderTitleTV = "Заголовок"
    let placeHolderDetailTV = "SomeText"
    var isSpaceAdded = false
    let colorPlaceHolders: UIColor = .lightGray
    let colorTextSelected: UIColor = .black
    
    //MARK: lifecycle methodsr
    override func viewDidLoad() {
        super.viewDidLoad()
        addCustomSubViews()
        createdAllViewConstraint()
        configKeyBoard()
         
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if titleTextView.text.isEmpty {
            titleTextView.text = placeHolderTitleTV
        }
        if detailTextView.text.isEmpty {
            detailTextView.text = placeHolderDetailTV
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configKeyBoard()
    }
    
    
    func setValuesToLabels(_ model: ModelCellTVC) {
        titleTextView.text = model.titleLabel
        detailTextView.text = model.editLabel
      
        let formattedDate = dateFormatter.string(from: model.datePicker)
        dateLabel.text = "Дата: " + formattedDate
    }
    
    //MARK: Setup Text View, Button, Labels
    private func addCustomSubViews() {
        let borderColor = UIColor.white.cgColor
        //setup datePicker
        datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.timeZone = NSTimeZone.local
        datePicker.addTarget(self, action: #selector(datePickerValueChange), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dateLabelTapped(_:)))
        dateLabel.isUserInteractionEnabled = true
        dateLabel.addGestureRecognizer(tapGesture)
        
        //setupButton
        let customButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(customButtonTapped))
        navigationItem.rightBarButtonItem = customButton
        
        //setup maxTextView
        detailTextView.translatesAutoresizingMaskIntoConstraints = false
        detailTextView.font = UIFont.systemFont(ofSize: 14)
        detailTextView.layer.cornerRadius = 8.0
        detailTextView.layer.borderWidth = 2.0
        detailTextView.layer.borderColor = borderColor
        detailTextView.textContainerInset = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 0)
        
        //setup MiniTextView
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        titleTextView.isScrollEnabled = false
        titleTextView.textContainer.maximumNumberOfLines = 1
        titleTextView.textContainer.lineBreakMode = .byTruncatingTail
        titleTextView.font = UIFont.boldSystemFont(ofSize: 22)
        titleTextView.layer.cornerRadius = 8.0
        titleTextView.layer.borderWidth = 2.0
        titleTextView.layer.borderColor = borderColor
        titleTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        
        //setup dateLabel
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        dateLabel.text = "Дата: " + formattedDate
        dateLabel.font = UIFont.systemFont(ofSize: 13)
        dateLabel.textColor = .gray
        dateLabel.layer.borderColor = borderColor
        dateLabel.textAlignment = .center
        
        self.view.backgroundColor = .white
        //addSubview
        self.view.addSubview(detailTextView)
        self.view.addSubview(titleTextView)
        self.view.addSubview(dateLabel)
        self.view.addSubview(datePicker)
        self.datePicker.isHidden = true
        self.detailTextView.delegate = self
        self.titleTextView.delegate = self
        
        //constraints
        
        
    }
    
    @objc func customButtonTapped(_ tapped: UIButton) {
        let title = titleTextView.text ?? ""
        let detail = detailTextView.text ?? ""
        let date = datePicker.date
        
        if let noteTableVC = navigationController?.viewControllers.first as? NoteTableViewController {
            let newNote = ModelCellTVC(titleLabel: title, editLabel: detail, datePicker: date)
            let encoder = JSONEncoder()
            let data = try! encoder.encode(newNote)
            setUserDefault(value: data, key: UUID().uuidString)
            noteTableVC.array.append(newNote)
            noteTableVC.tableView.reloadData()
        }
        
                hiddenDatePicker(true)
        navigationController?.popToRootViewController(animated: true)
    }

    @objc func datePickerValueChange(_ sender: UIDatePicker) {
        let selectedDate = sender.date
           let formattedDate = dateFormatter.string(from: selectedDate)
           dateLabel.text = "Дата: " + formattedDate
        
    }
    
    @objc func dateLabelTapped(_ sender: UITapGestureRecognizer) {
        hiddenDatePicker(false)
    }
    
    func hiddenDatePicker(_ bool: Bool) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            
            if bool {
                self.view.endEditing(true)
            } else {
                self.detailTextView.resignFirstResponder()
                self.titleTextView.resignFirstResponder()
            }
            
            self.datePicker.isHidden = bool
        }
    }
    
    func configKeyBoard() {
        detailTextView.becomeFirstResponder()
    }
    
    //MARK: NSLayoutConstraints
    func createdAllViewConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            //MARK: Констрейнты для лейбла даты
            dateLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            dateLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: self.titleTextView.topAnchor),
            
            //MARK: Констрейнты для тайтла
            titleTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 17),
            titleTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -17),
            titleTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            titleTextView.bottomAnchor.constraint(equalTo: self.detailTextView.topAnchor),
            
            //MARK: Констрейнты для детального текста
            detailTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 17),
            detailTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -17),
            detailTextView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor),
            detailTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),
            
            //MARK: Констрейнты для ДейтПикера
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    //MARK: User Default
    func setUserDefault(value: Any, key: String) {
        UserDefaults.standard.set(value, forKey: key)
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
            if textView.text == placeHolderDetailTV {
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
            } else if textView.text == placeHolderDetailTV {
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
            }
        }
        
        if textView == detailTextView {
            if textView.text == "" {
                textView.text = placeHolderDetailTV
                textView.textColor = colorPlaceHolders
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
