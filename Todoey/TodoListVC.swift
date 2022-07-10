//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListVC: UITableViewController {
    
    let itemArray = ["Find Mike", "Bye Milk", "Destroy Demogorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TodoListCellIdentifire, for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = itemArray[indexPath.row]
        cell.contentConfiguration = content
        
        
        return cell
    }
    
}

