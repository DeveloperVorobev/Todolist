//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListVC: UITableViewController {
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    var itemArray = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   print(dataFilePath)
        
        let newItem = Item(title: "Find Ann")
        itemArray.append(newItem)
        
        let newItem2 = Item(title: "Find Ann1")
        itemArray.append(newItem2)
        
        let newItem3 = Item(title: "Find Ann2")
        itemArray.append(newItem3)
        
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.todoListCellIdentifire, for: indexPath)
        let imem = itemArray[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = itemArray[indexPath.row].title
        cell.contentConfiguration = content
        
        cell.accessoryType = imem.done ? .checkmark : .none
        
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let currentCell = tableView.cellForRow(at: indexPath)
        
        if currentCell?.isSelected == true{
            currentCell?.isSelected = false
        }
        itemArray[indexPath.row].done.toggle()
        
        saveItems()
        tableView.reloadData()
    }
    
    // MARK: - Add Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add now todoy item", message: "", preferredStyle: .alert)
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            let newItem = Item(title: textField.text!)
            self.itemArray.append(newItem)
            self.saveItems()
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { alertTF in
            alertTF.placeholder = "Create new item"
            textField = alertTF
        }
        
        alert.addAction(action)
        present(alert, animated: true)
        
    }
    
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
    }
    
    
}

