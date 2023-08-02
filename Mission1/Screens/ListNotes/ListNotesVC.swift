//
//  NoteTableViewController.swift
//  Mission1
//
//  Created by Темирлан Асанбеков on 5/7/23.
//

import UIKit

class ListNotesVC: UIViewController {
    
    //MARK: Properties
    var array = [ModelCellTVC]()
    let tableView: UITableView = UITableView()
    var configButton: UIBarButtonItem?
    var addButtonTapped = UIButton()
    var selectedIndex = Set<Int>()
    var isSelectionMode = false
    var isDarkModeEnabled = false
    
    //MARK: LifeCycle Methods
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
            // Анимация "подскока" кнопки вверх и затем вниз
            self.bounceButtonAnimation(totalJumps: 2, originalY: self.addButtonTapped.center.y)
        }
        addButtonTapped.transform = .identity
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addButtonTapped.layer.cornerRadius = addButtonTapped.frame.height / 2
    }
    
    //MARK: Navigation
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
    
    //MARK: Setup Buttons
    func setupBarButton() {
        configButton = UIBarButtonItem(title: UIHelper.selectButton, style: .plain, target: self, action: #selector(moveButtonTapped))
        navigationItem.rightBarButtonItem = configButton
    }
    
    @objc func moveButtonTapped() {
        if array.isEmpty {
            alertController(title: "Внимание", messege: "Добавьте заметку", alert: .alert)
            configButton?.title = UIHelper.selectButton
        } else {
            tableView.setEditing(!tableView.isEditing, animated: true)
            // Изменяем текст кнопки в зависимости от режима редактирования
            isSelectionMode = tableView.isEditing
            configButton?.title = !isSelectionMode ? UIHelper.selectButton : UIHelper.readyButton
            setupButton()
        }
    }
    func setupButton() {
        UIView.transition(with: addButtonTapped, duration: 0.3, options: .transitionFlipFromRight, animations: {
            let buttonImage = self.isSelectionMode ? UIImage(named: "Trash") : UIImage(named: "plus")
            self.addButtonTapped.setImage(buttonImage, for: .normal)
            self.addButtonTapped.backgroundColor = UIHelper.buttonBackgroundColor
            self.addButtonTapped.removeTarget(self, action: self.isSelectionMode ? #selector(self.openVCButtonTapped) : #selector(self.deleteButtonTapped), for: .touchUpInside)
            self.addButtonTapped.addTarget(self, action: self.isSelectionMode ? #selector(self.deleteButtonTapped) : #selector(self.openVCButtonTapped), for: .touchUpInside)
            
        })
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
                    self.navigationController?.pushViewController(destinationViewController, animated: true)
                }
            }
        }
    }
    
    func addBtn() {
        addButtonTapped.setImage(UIImage(named: "plus"), for: .normal)
        addButtonTapped.backgroundColor = UIHelper.buttonBackgroundColor
        addButtonTapped.removeTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        addButtonTapped.addTarget(self, action: #selector(openVCButtonTapped), for: .touchUpInside)
        
    }
    
    @objc func deleteButtonTapped() {
        if !selectedIndex.isEmpty {
            // Создаем массив IndexPath для удаления ячеек
            let indexPathsToDelete = selectedIndex.sorted(by: >).map { IndexPath(row: $0, section: 0) }
            
            // Удаляем объекты из UserDefaults
            for index in selectedIndex.sorted(by: >) {
                UserDefaults.standard.removeObject(forKey: array[index].key)
            }
            UserDefaults.standard.synchronize()
            // Удаляем объекты из массива array
            array = array.enumerated().filter { !selectedIndex.contains($0.offset) }.map { $0.element }
            // Очищаем selectedIndex
            selectedIndex.removeAll()
            tableView.setEditing(false, animated: true)
            // Обновляем таблицу с анимацией удаления
            tableView.deleteRows(at: indexPathsToDelete, with: .automatic)
            // Возвращаем кнопке "Выбрать" исходное значение
            
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

        }
    }
    
    //MARK: Config button Animation
    func bounceButtonAnimation(totalJumps: Int, originalY: CGFloat) {
        guard totalJumps > 0 else { return }
        
        UIView.animate(withDuration: 0.20, animations: {
            self.addButtonTapped.center.y -= 120
        }) { _ in
            UIView.animate(withDuration: 0.15, animations: {
                self.addButtonTapped.center.y += 150
            }) { _ in
                // Вызываем рекурсивно анимацию для следующего прыжка
                self.bounceButtonAnimation(totalJumps: totalJumps - 1, originalY: originalY)
                
                // Уменьшаем амплитуду прыжка после первого прыжка
                if totalJumps == 1 {
                    UIView.animate(withDuration: 0.20, animations: {
                        self.addButtonTapped.center.y = originalY
                    })
                }
            }
        }
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

//MARK: Extension DataSource

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
        //        cell.accessoryType = selectedIndex.contains(indexPath.row) ? .checkmark : .none
        return cell
    }
}

//MARK: Extension Delegate

extension ListNotesVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing { //тут проблема
            // Если таблица находится в режиме редактирования (выбора ячеек), обновляем выделение ячейки.
            if isSelectionMode {
                if selectedIndex.contains(indexPath.row) {
                    selectedIndex.remove(indexPath.row)
                } else {
                    selectedIndex.insert(indexPath.row)
                }
                tableView.reloadRows(at: [indexPath], with: .none)
            }
        }  else  {
            // Если таблица не находится в режиме редактирования, открываем экран редактирования для выбранной ячейки.
            let selectedNote = array[indexPath.row]
            let detailVC = DetailVC()
            detailVC.setValuesToLabels(selectedNote)
            detailVC.isEdit = true
            detailVC.selectedIndex = indexPath
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
                // Создаем действие для удаления ячейки
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (action, view, completionHandler) in
                    guard let self = self else { return }
                    self.deleteButtonTapped()
                    completionHandler(true)
                
                }
            
                deleteAction.image = UIImage(named: "delete_icon") // Устанавливаем иконку удаления
            
                // Возвращаем конфигурацию с действием удаления
                return UISwipeActionsConfiguration(actions: [deleteAction])
            }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            // Проверяем, является ли ячейка выбранной (выделенной) для удаления
            if selectedIndex.contains(indexPath.row) {
                return .delete // Разрешаем удаление для выбранной ячейки
            }
        }
        return .none // Запрещаем удаление для остальных ячеек
    }
    
}

