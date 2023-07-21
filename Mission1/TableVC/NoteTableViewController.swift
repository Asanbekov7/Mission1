//
//  NoteTableViewController.swift
//  Mission1
//
//  Created by Темирлан Асанбеков on 5/7/23.
//

import UIKit

class NoteTableViewController: UIViewController {
    
    //MARK: Properties
    var array = [ModelCellTVC]()
    let tableView: UITableView = UITableView()
    let colorTableView = UIColor(hex: "#F9FAFE")
  
  
    
    //MARK: LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        array = ModelCellTVC.makeCells()
        configureUI()
        setupBarButton()
        view.backgroundColor = colorTableView
        
        
    }
    //MARK: Navigation
    func setupNavigationBar() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate {
            let navigationController = UINavigationController(rootViewController: self)
            sceneDelegate.window?.rootViewController = navigationController
            
            navigationItem.title = "Заметки"
        }
       
    }
    
    func setupBarButton() {
        let addButton = UIBarButtonItem(title: "Выбрать", style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        
    }
    
   @objc func addButtonTapped() {
        let destinationViewController = ViewController()
       navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    func configureUI() {
        self.tableView.backgroundColor = colorTableView //Найди метод UIColor который присвоит цвет по HEX формату - #F9FAFE
    }
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.register(MyTableViewCell.self, forCellReuseIdentifier: "MyTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        


        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
        ])
    }
}

extension NoteTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as? MyTableViewCell else {
            return UITableViewCell()
        }
        
        let model = array[indexPath.row]
        cell.configure(cell, model: model)
        return cell
    }
    
    
}

extension NoteTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 100
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            
            // Создаем действие "Удалить"
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
                guard let self = self else { return }
                
                // Удаляем элемент из источника данных
                self.array.remove(at: indexPath.row)
                
                // Удаляем ячейку из таблицы с анимацией
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                // Вызываем завершающий обработчик
                completionHandler(true)
            }
            
            // Возвращаем конфигурацию свайпа с действиями
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNote = array[indexPath.row]
        
        let detailVC = ViewController()
        detailVC.setValuesToLabels(selectedNote)
        navigationController?.pushViewController(detailVC, animated: true)
    }
 
}

extension UIColor {
    convenience init(hex: String) {
            let hexString = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
            var intColor: UInt64 = 0
            
            Scanner(string: hexString).scanHexInt64(&intColor)
            
            let r, g, b: UInt64
            switch hexString.count {
            case 3: // Для трехзначного HEX: #RGB
                (r, g, b) = ((intColor >> 8) * 17, (intColor >> 4 & 0xF) * 17, (intColor & 0xF) * 17)
            case 6: // Для шестизначного HEX: #RRGGBB
                (r, g, b) = (intColor >> 16, intColor >> 8 & 0xFF, intColor & 0xFF)
            default:
                (r, g, b) = (0, 0, 0)
            }
            
            self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: 1.0)
        }
}
