//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class TodoListVC: SwipeTableVC {
    @IBOutlet var searchBar: UISearchBar!
    
    let realm = try! Realm()
    
    var todoItems: Results<Item>?
    var selectedCategory: Category?{
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        loadItems()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let newNavBarAppearance = customNavBarAppearance()
        navigationController?.navigationBar.scrollEdgeAppearance = newNavBarAppearance
        navigationController?.navigationBar.compactAppearance = newNavBarAppearance
        navigationController?.navigationBar.standardAppearance = newNavBarAppearance
        if #available(iOS 15.0, *) {
            navigationController?.navigationBar.compactScrollEdgeAppearance = newNavBarAppearance
        }
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        var content = cell.defaultContentConfiguration()
        
        if let item = todoItems?[indexPath.row]{
            let categoryColor = UIColor(hexString: selectedCategory!.colorForCategory)!
            if let gradientColor = categoryColor.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
                cell.backgroundColor = gradientColor
                content.textProperties.color = ContrastColorOf(gradientColor, returnFlat: true)
                
            }
            
            content.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            content.text = "Empty category"
        }
        
        cell.contentConfiguration = content
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write{
                    item.done.toggle()
                }
            } catch {
                print("Error saving done status \(error)")
            }
        }
        tableView.reloadData()
    }
    
    
    // MARK: - Add Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add now todoy item", message: "", preferredStyle: .alert)
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.createdDate = Date()
                        currentCategory.items.append(newItem)
                        print("Ok")
                    }
                } catch {
                    print("Save error \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { alertTF in
            alertTF.placeholder = "Create new item"
            textField = alertTF
        }
        
        alert.addAction(action)
        present(alert, animated: true)
        
    }
    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDelete = self.todoItems?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(itemForDelete)
                }
            } catch {
                print("Delete error \(error)")
            }
        }
    }
    // MARK: -  Bar Custom Method
    func customNavBarAppearance() -> UINavigationBarAppearance {
        let customNavBarAppearance = UINavigationBarAppearance()
        
        var colorForNavBarText = UIColor()
        customNavBarAppearance.configureWithOpaqueBackground()
        if let hexString = selectedCategory?.colorForCategory{
            customNavBarAppearance.backgroundColor = UIColor(hexString: hexString)
             colorForNavBarText = ContrastColorOf(UIColor(hexString: hexString)!, returnFlat: true)
            navigationController?.view.tintColor = colorForNavBarText
            title = selectedCategory?.name
            searchBar.barTintColor = UIColor(hexString: hexString)
            searchBar.searchTextField.backgroundColor = .white
            
        }
        
        // Apply white colored normal and large titles.
        customNavBarAppearance.titleTextAttributes = [.foregroundColor: colorForNavBarText]
        customNavBarAppearance.largeTitleTextAttributes = [.foregroundColor: colorForNavBarText]
        
        // Apply white color to all the nav bar buttons.
        let barButtonItemAppearance = UIBarButtonItemAppearance(style: .plain)
        barButtonItemAppearance.normal.titleTextAttributes = [.foregroundColor: colorForNavBarText]
        barButtonItemAppearance.disabled.titleTextAttributes = [.foregroundColor: colorForNavBarText]
        barButtonItemAppearance.highlighted.titleTextAttributes = [.foregroundColor: colorForNavBarText]
        barButtonItemAppearance.focused.titleTextAttributes = [.foregroundColor: colorForNavBarText]
        customNavBarAppearance.buttonAppearance = barButtonItemAppearance
        customNavBarAppearance.backButtonAppearance = barButtonItemAppearance
        customNavBarAppearance.doneButtonAppearance = barButtonItemAppearance
        
        
        
        return customNavBarAppearance
    }
}

// MARK: - SearchBar Method
extension TodoListVC: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        } else {
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "createdDate", ascending: true)
            tableView.reloadData()
        }
    }
}

