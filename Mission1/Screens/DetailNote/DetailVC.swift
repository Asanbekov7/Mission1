//
//  ViewController.swift
//  Mission1
//
//  Created by Темирлан Асанбеков on 30/6/23.
//

import UIKit


class DetailVC: UIViewController {
    
    // MARK: Public properties
    
    var note: ModelCellTVC?
    var selectedIndex: IndexPath?
    var isEdit: Bool = false
    var isSpaceAdded = false
    
    // MARK: Privat UI Properties
    private var datePicker: UIDatePicker!
    
    private let detailTextView: UITextView = {
        let detailTextView = UITextView()
        detailTextView.font = UIFont.systemFont(ofSize: 14)
        detailTextView.layer.cornerRadius = 8.0
        detailTextView.layer.borderWidth = 2.0
        detailTextView.layer.borderColor = Constants.borderColor.cgColor
        detailTextView.textContainerInset = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 0)
        return detailTextView
    }()
    
    private let titleTextView: UITextView = {
        let titleTextView = UITextView()
        titleTextView.isScrollEnabled = false
        titleTextView.textContainer.maximumNumberOfLines = 1
        titleTextView.textContainer.lineBreakMode = .byTruncatingTail
        titleTextView.font = UIFont.boldSystemFont(ofSize: 22)
        titleTextView.layer.cornerRadius = 8.0
        titleTextView.layer.borderWidth = 2.0
        titleTextView.layer.borderColor = Constants.borderColor.cgColor
        titleTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return titleTextView
    }()
    
    private let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: 13)
        dateLabel.textColor = .gray
        dateLabel.layer.borderColor = Constants.borderColor.cgColor
        dateLabel.textAlignment = .center
        return dateLabel
    }()
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd MMMM yyyy HH:mm"
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        return dateFormatter
    }()
    
    //MARK: protocol Delegate
    weak var noteUpdateDelegate: NoteUpdateDelegate?
    
    //MARK: Inheritance
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupConstraints()
        setupDelegate()
        setBarButtonItem()
        detailTextView.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if titleTextView.text.isEmpty || titleTextView.text == UIHelper.placeHolderTitleTV {
            titleTextView.text = UIHelper.placeHolderTitleTV
            titleTextView.textColor = Constants.colorPlaceHolders
        }
        if detailTextView.text.isEmpty || detailTextView.text == UIHelper.placeHolderDetailTV {
            detailTextView.text = UIHelper.placeHolderDetailTV
            detailTextView.textColor = Constants.colorPlaceHolders
        }
        isSpaceAdded = !detailTextView.text.isEmpty
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        detailTextView.becomeFirstResponder()
    }
    
    //MARK: Buttons for the UIElements
    
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
            alertController(title: UIHelper.alertTitle, messege: UIHelper.alertMessege, alert: .alert)
        } else {
            guard let noteTableVC = navigationController?.viewControllers.first as? ListNotesVC else { return }
            let newNote = ModelCellTVC(titleLabel: title, editLabel: detail, date: date!, key: note == nil ? UUID().uuidString : noteTableVC.array[selectedIndex!.row].key, personImage: imageData)
            
            if isEdit, let selectedIndex = selectedIndex {
                noteUpdateDelegate?.updateNote(atIndex: selectedIndex.row, withNote: newNote)
            } else {
                noteUpdateDelegate?.saveNote(newNote)
            }
            noteTableVC.tableView.reloadData()
            hiddenDatePicker(true)
            
            navigationItem.rightBarButtonItem?.isHidden = true
            
        }
    }
    
    @objc func datePickerValueChange(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let formattedDate = dateFormatter.string(from: selectedDate)
        dateLabel.text = formattedDate
    }
    
    @objc func dateLabelTapped(_ sender: UITapGestureRecognizer) {
        hiddenDatePicker(false)
    }
    
    func setBarButtonItem() {
        let customButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(customButtonTapped))
        navigationItem.rightBarButtonItem = customButton
    }
    
    //MARK: Public metohods
    //для передачи данных на ListNoteVC
    
    func setValuesToLabels(_ model: ModelCellTVC) {
        note = model
        titleTextView.text = model.titleLabel
        detailTextView.text = model.editLabel
        dateLabel.text = model.date
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
}

// MARK: - UITextViewDelegate methods

extension DetailVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == titleTextView {
            if textView.text == UIHelper.placeHolderTitleTV {
                textView.text = ""
                textView.textColor = Constants.colorTextSelected
            }
        } else if !isSpaceAdded {
            textView.text = textView.text + " "
            isSpaceAdded = true
        }
        
        if textView == detailTextView {
            if textView.text == UIHelper.placeHolderDetailTV {
                textView.text = ""
                textView.textColor = Constants.colorTextSelected
            } else if !isSpaceAdded {
                textView.text = textView.text + " "
                isSpaceAdded = true
            }
        }
        navigationItem.rightBarButtonItem?.isHidden = false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == titleTextView {
            if textView.text == "" {
                textView.text = ""
                textView.textColor = Constants.colorTextSelected
            } else if textView.text == UIHelper.placeHolderTitleTV {
                textView.text = ""
                textView.textColor = Constants.colorTextSelected
            }
        }
        
        if textView == detailTextView {
            if textView.text == "" {
                textView.text = ""
                textView.textColor = Constants.colorTextSelected
            } else if textView.text == UIHelper.placeHolderDetailTV {
                textView.text = ""
                textView.textColor = Constants.colorTextSelected
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
                textView.textColor = Constants.colorTextSelected
            }
        }
        
        if textView == detailTextView {
            if textView.text == "" {
                textView.text = UIHelper.placeHolderDetailTV
                textView.textColor = Constants.colorTextSelected
            }
        }
        navigationItem.rightBarButtonItem?.isHidden = true
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
// MARK: - Private properties

private extension DetailVC {
    func configUI() {
        self.view.backgroundColor = .white
        
        let customButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(customButtonTapped))
        navigationItem.rightBarButtonItem = customButton
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.timeZone = NSTimeZone.local
        datePicker.addTarget(self, action: #selector(datePickerValueChange), for: .valueChanged)
        datePicker.isHidden = true
        
        dateLabel.text = dateFormatter.string(from: Date())
    }
    
    func setupDelegate() {
        detailTextView.delegate = self
        titleTextView.delegate = self
    }
    
    func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dateLabelTapped(_:)))
        dateLabel.isUserInteractionEnabled = true
        dateLabel.addGestureRecognizer(tapGesture)
    }
    
    func setupConstraints() {
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
            datePicker.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo:  safeArea.bottomAnchor)
        ])
    }
}

// MARK: - Constants
extension DetailVC {
    private enum Constants {
        
        // MARK: UIColors
        
        static let colorTextSelected = UIColor.black
        static let colorPlaceHolders = UIColor.lightGray
        static let borderColor = UIColor.white
    }
}
