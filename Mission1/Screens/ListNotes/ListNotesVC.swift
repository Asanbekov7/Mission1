//
//  NoteTableViewController.swift
//  Mission1
//
//  Created by Темирлан Асанбеков on 5/7/23.
//

import UIKit

protocol NoteUpdateDelegate: AnyObject {
    func saveNote(_ note: ModelCellTVC)
    func updateNote(atIndex index: Int, withNote note: ModelCellTVC)
}

class ListNotesVC: UIViewController {
    
    // MARK: Public properties

    var array = [ModelCellTVC]()
    var isSelectionMode = false
    var isDarkModeEnabled = false
    
    // MARK: UI properties
    
    let tableView: UITableView = UITableView()
    var configButton: UIBarButtonItem?
    var addButtonTapped = UIButton()
    var selectedIndex = Set<Int>()
    
    //MARK: Inheritance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        array = ModelCellTVC.makeCells()
        setupBarButton()
        tableView.allowsSelectionDuringEditing = true
        addBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.bounceButtonAnimation(totalJumps: 2, originalY: self.addButtonTapped.center.y)
        }
        addButtonTapped.transform = .identity
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addButtonTapped.layer.cornerRadius = addButtonTapped.frame.height / 2
    }
    
    //MARK: Костыль пиздец
    
    func setDelegateToUpdate(_ vc: DetailVC) {
        vc.noteUpdateDelegate = self
    }
    
    // MARK: Public properties
    
    func setupNavigationBar() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate {
            let navigationController = UINavigationController(rootViewController: self)
            sceneDelegate.window?.rootViewController = navigationController
            
            navigationItem.title = UIHelper.navigationTitle
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 20),
                .foregroundColor: UIColor.black
            ]
            navigationController.navigationBar.titleTextAttributes = attributes
        }
    }
    
    //MARK: Private methods
    
  private func setupBarButton() {
        configButton = UIBarButtonItem(title: UIHelper.selectButton, style: .plain, target: self, action: #selector(moveButtonTapped))
        navigationItem.rightBarButtonItem = configButton
    }
    
   private func setupButton() {
        isSelectionMode = tableView.isEditing
        configButton?.title = !isSelectionMode ? UIHelper.selectButton : UIHelper.readyButton
        
        UIView.transition(with: addButtonTapped, duration: 0.3, options: .transitionFlipFromRight, animations: { [weak self] in
            guard let weakSelf = self else { return }
            let buttonImage = weakSelf.isSelectionMode ? UIImage(named: "Trash") : UIImage(named: "plus")
            weakSelf.addButtonTapped.setImage(buttonImage, for: .normal)
            weakSelf.addButtonTapped.backgroundColor = UIHelper.buttonBackgroundColor
            weakSelf.addButtonTapped.removeTarget(weakSelf, action: weakSelf.isSelectionMode ? #selector(weakSelf.openVCButtonTapped) : #selector(weakSelf.deleteButtonTapped), for: .touchUpInside)
            weakSelf.addButtonTapped.addTarget(weakSelf, action: weakSelf.isSelectionMode ? #selector(weakSelf.deleteButtonTapped) : #selector(weakSelf.openVCButtonTapped), for: .touchUpInside)
        })
    }
    
    private func addBtn() {
         addButtonTapped.setImage(UIImage(named: "plus"), for: .normal)
         addButtonTapped.backgroundColor = UIHelper.buttonBackgroundColor
         addButtonTapped.removeTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
         addButtonTapped.addTarget(self, action: #selector(openVCButtonTapped), for: .touchUpInside)
         
     }
    
    // MARK: UI action methods
    
    @objc func moveButtonTapped() {
        if array.isEmpty {
            alertController(title: "Внимание", messege: "Добавьте заметку", alert: .alert)
            configButton?.title = UIHelper.selectButton
        } else {
            tableView.setEditing(!tableView.isEditing, animated: true)
            setupButton()
        }
    }
    
    @objc func openVCButtonTapped() {
        if !isSelectionMode {
            UIView.animate(withDuration: 0.1, animations: { 
                self.addButtonTapped.transform = CGAffineTransform(translationX: 0, y: -90)
            }) { _ in
                UIView.animate(withDuration: 0.12, animations: {
                    self.addButtonTapped.transform = CGAffineTransform(translationX: 0, y: 200)
                }) { _ in
                    let destinationViewController = DetailVC()
                    self.setDelegateToUpdate(destinationViewController)
                    self.navigationController?.pushViewController(destinationViewController, animated: true)
                }
            }
        }
    }
    
    @objc func deleteButtonTapped() {
        if !selectedIndex.isEmpty {
            
            let indexPathsToDelete = selectedIndex.sorted(by: >).map { IndexPath(row: $0, section: 0) }
            
            for index in selectedIndex.sorted(by: >) {
                UserDefaults.standard.removeObject(forKey: array[index].key)
            }
            
            UserDefaults.standard.synchronize()
            array = array.enumerated().filter { !selectedIndex.contains($0.offset) }.map { $0.element }
            selectedIndex.removeAll()
            tableView.setEditing(false, animated: true)
            tableView.deleteRows(at: indexPathsToDelete, with: .automatic)
            
            isSelectionMode = tableView.isEditing
            configButton?.title = !isSelectionMode ? UIHelper.selectButton : UIHelper.readyButton
            UIView.transition(with: addButtonTapped, duration: 0.3, options: .transitionFlipFromRight, animations: {
                self.addBtn()
            })
            
            if array.isEmpty {
                tableView.setEditing(false, animated: true)
            }
            
            isSelectionMode = false
            configButton?.title = UIHelper.selectButton
            
        } else {
            isSelectionMode = false
            setupButton()
        }
    }
    
    //MARK: Config button Animation
    func bounceButtonAnimation(totalJumps: Int, originalY: CGFloat) {
        guard totalJumps > 0 else { return }
        
        self.addButtonTapped.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)

          UIView.animate(withDuration: 2.0,
                                     delay: 0,
                                     usingSpringWithDamping: CGFloat(0.20),
                                     initialSpringVelocity: CGFloat(6.0),
                                     options: UIView.AnimationOptions.allowUserInteraction,
                                     animations: {
              self.addButtonTapped.transform = CGAffineTransform.identity
              },
                                     completion: { Void in()  }
          )
    }
    
    //MARK: Configure TableView
    func setupTableView() {
        [tableView, addButtonTapped].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        view.backgroundColor = UIHelper.backgroundColor
        tableView.backgroundColor = UIHelper.backgroundColor
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: "NoteTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tableView.allowsMultipleSelectionDuringEditing = true
        
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            
            addButtonTapped.widthAnchor.constraint(equalToConstant: 60),
            addButtonTapped.heightAnchor.constraint(equalToConstant: 60),
            addButtonTapped.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButtonTapped.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70)
        ])
    }
}

// MARK: - UITableViewDataSource delegate methods

extension ListNotesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as? NoteTableViewCell else {
            return UITableViewCell()
        }
        
        let model = array[indexPath.row]
        cell.configure(cell, model: model)
        
        return cell
    }
}

// MARK: - UITableViewDelegate methods

extension ListNotesVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if tableView.isEditing {
            selectedIndex.insert(indexPath.row)
        }  else  {
            let selectedNote = array[indexPath.row]
            let detailVC = DetailVC()
            detailVC.setValuesToLabels(selectedNote)
            detailVC.isEdit = true
            detailVC.selectedIndex = indexPath
        
            setDelegateToUpdate(detailVC)
            
            navigationController?.pushViewController(detailVC, animated: true)
        }
        
    }
  
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedIndex.remove(indexPath.row)
        
    }
        
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDelete = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, _ in
            guard let weakSelf = self else { return }
            let removedNote = weakSelf.array.remove(at: indexPath.row)
            UserDefaults.standard.removeObject(forKey: removedNote.key)
            tableView.reloadData()
        }
        let imageConfig = UIImage.SymbolConfiguration( pointSize: 20.0, weight: .bold, scale: .large)
        actionDelete.image = UIImage( systemName: "trash", withConfiguration: imageConfig)?.withTintColor( .white, renderingMode: .alwaysTemplate).addBackgroundCircle(.systemRed)
        
        actionDelete.backgroundColor = UIHelper.backgroundColor
        actionDelete.title = "Удалить"
        
        let actions = UISwipeActionsConfiguration(actions: [actionDelete])
        actions.performsFirstActionWithFullSwipe = false

        return actions
    }
}

//MARK: Inheritance protocol delegate

extension ListNotesVC: NoteUpdateDelegate {
    func setUserDefaults(value: Any, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func saveNote(_ note: ModelCellTVC) {
        array.append(note)
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(note) {
            setUserDefaults(value: data, key: note.key)
        }
        tableView.reloadData()
    }
    
    func updateNote(atIndex index: Int, withNote note: ModelCellTVC) {
        guard index < array.count else { return }
        array[index] = note
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(note) {
            setUserDefaults(value: data, key: note.key)
        }
        tableView.reloadData()
    }
}
