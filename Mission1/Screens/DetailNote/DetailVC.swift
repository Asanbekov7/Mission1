//
//  ViewController.swift
//  Mission1
//
//  Created by Темирлан Асанбеков on 30/6/23.
//

import UIKit

class DetailVC: UIViewController {
    //MARK: Outlets
    var detailTextView = UITextView() //detailTextView
    var titleTextView = UITextView() //titleTextView
    var dateLabel = UILabel()
    var datePicker: UIDatePicker!
    let dateFormatter = DateFormatter()
    var note: ModelCellTVC?
    var selectedIndex: IndexPath?
    var isEdit: Bool = false
    
    
   
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
        
        if titleTextView.text.isEmpty || titleTextView.text == UIHelper.placeHolderTitleTV {
            titleTextView.text = UIHelper.placeHolderTitleTV
            titleTextView.textColor = colorPlaceHolders
        }
        
        if detailTextView.text.isEmpty || detailTextView.text == UIHelper.placeHolderDetailTV {
            detailTextView.text = UIHelper.placeHolderDetailTV
            detailTextView.textColor = colorPlaceHolders
        }
        isSpaceAdded = !detailTextView.text.isEmpty
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configKeyBoard()
    }
    

    
    //MARK: Setup Text View, Button, Labels
    private func addCustomSubViews() {
        let borderColor = UIColor.white.cgColor
        //setup datePicker
        datePicker = UIDatePicker()
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
        detailTextView.font = UIFont.systemFont(ofSize: 14)
        detailTextView.layer.cornerRadius = 8.0
        detailTextView.layer.borderWidth = 2.0
        detailTextView.layer.borderColor = borderColor
        detailTextView.textContainerInset = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 0)
        
        //setup MiniTextView
        titleTextView.isScrollEnabled = false
        titleTextView.textContainer.maximumNumberOfLines = 1
        titleTextView.textContainer.lineBreakMode = .byTruncatingTail
        titleTextView.font = UIFont.boldSystemFont(ofSize: 22)
        titleTextView.layer.cornerRadius = 8.0
        titleTextView.layer.borderWidth = 2.0
        titleTextView.layer.borderColor = borderColor
        titleTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        
        //setup dateLabel
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd MMMM yyyy HH:mm"
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        dateLabel.text = formattedDate
        dateLabel.font = UIFont.systemFont(ofSize: 13)
        dateLabel.textColor = .gray
        dateLabel.layer.borderColor = borderColor
        dateLabel.textAlignment = .center
        
        self.view.backgroundColor = .white
        //addSubview
        
        self.datePicker.isHidden = true
        self.detailTextView.delegate = self
        self.titleTextView.delegate = self
        
    }
    
    @objc func customButtonTapped(_ tapped: UIButton) {
        var title = titleTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        var detail = detailTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let date = dateLabel.text
        let imageData = UIImage(named: "avatar")?.pngData()
        
        if title.isEmpty || title == UIHelper.placeHolderTitleTV {
             title = ""
         }
         
        if detail.isEmpty || detail == UIHelper.placeHolderDetailTV {
             detail = ""
         }
        
        if title.isEmpty && detail.isEmpty {
            alertController(title: "Предупреждение", messege: "Оба поля заметки не могут быть пустым", alert: .alert)
        } else {
            guard let noteTableVC = navigationController?.viewControllers.first as? ListNotesVC else { return }
            let newNote = ModelCellTVC(titleLabel: title, editLabel: detail, date: date!, key: note == nil ? UUID().uuidString : noteTableVC.array[selectedIndex!.row].key, personImage: imageData)

            if isEdit, let selectedIndex = selectedIndex {
                if noteTableVC.array.indices.contains(selectedIndex.row) {
                    noteTableVC.array[selectedIndex.row] = newNote
                }
            } else {
                noteTableVC.array.append(newNote)
            }
            
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(newNote) {
                setUserDefault(value: data, key: newNote.key)
            }
            
            noteTableVC.tableView.reloadData()
            hiddenDatePicker(true)
            navigationItem.rightBarButtonItem = nil
        }
    }
    //MARK: для передачи данных на ListNoteVC
    func setValuesToLabels(_ model: ModelCellTVC) {
        note = model
        titleTextView.text = model.titleLabel
        detailTextView.text = model.editLabel
        dateLabel.text = model.date
    }
    //MARK: Buttons для uielementov
    @objc func datePickerValueChange(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let formattedDate = dateFormatter.string(from: selectedDate)
        dateLabel.text = formattedDate
        
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
        [dateLabel, titleTextView, detailTextView, datePicker].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
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
            titleTextView.bottomAnchor.constraint(equalTo: self.detailTextView.topAnchor, constant: -20),
            
            //MARK: Констрейнты для детального текста
            detailTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 17),
            detailTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -17),
            detailTextView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 16),
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

extension DetailVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == titleTextView {
            if textView.text == UIHelper.placeHolderTitleTV {
                textView.text = ""
                textView.textColor = colorTextSelected
            }
        } else if !isSpaceAdded {
            textView.text = textView.text + " "
            isSpaceAdded = true
        }
        
        if textView == detailTextView {
            if textView.text == UIHelper.placeHolderDetailTV {
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
            } else if textView.text == UIHelper.placeHolderTitleTV {
                textView.text = ""
                textView.textColor = colorTextSelected
            }
        }
        
        if textView == detailTextView {
            if textView.text == "" {
                textView.text = ""
                textView.textColor = colorTextSelected
            } else if textView.text == UIHelper.placeHolderDetailTV {
                textView.text = ""
                textView.textColor = colorTextSelected
            }
        }
        
        if let firstCharacter = textView.text.first {
            textView.text = String(firstCharacter).uppercased() + textView.text.dropFirst()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == titleTextView {
            if textView.text == "" {
                textView.text = UIHelper.placeHolderTitleTV
                textView.textColor = colorPlaceHolders
            }
        }
        
        if textView == detailTextView {
            if textView.text == "" {
                textView.text = UIHelper.placeHolderDetailTV
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

