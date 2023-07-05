//
//  NoteTableViewController.swift
//  Mission1
//
//  Created by Темирлан Асанбеков on 5/7/23.
//

import UIKit

class NoteTableViewController: UITableViewController {

    @IBOutlet weak var changeButton: UIBarButtonItem!
    var itemArray = [ModelTVC]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let item = ModelTVC(titleLabel: "sdsd", detailLabel: "äsdsad", datePicker: Date(), isEmpty: true)
    }
    @IBAction func changeButtonAction(_ sender: UIBarButtonItem) {
    }
    
    // MARK: - Table view data source

  

}

extension NoteTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? MyTableViewCell else { return UITableViewCell() }
        let item = itemArray[indexPath.row]
       
        return cell
    }

}
