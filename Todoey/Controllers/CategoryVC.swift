//
//  CategoryVC.swift
//  Todoey
//
//  Created by Владислав Воробьев on 16.07.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit


class CategoryVC: SwipeTableVC {
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
       
    }
    
    // MARK: - Add Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new todoy category", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add category", style: .default) { action in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            self.saveCategories(category: newCategory)
            
        }
        alert.addTextField { alertFT in
            alertFT.placeholder = "Create new category"
            textField = alertFT
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    // MARK: - Data Methods
    
    func saveCategories(category: Category){
        do {
            try realm.write{
                realm.add(category)
            }
            print("Succes Save")
        } catch {
            print("Save error \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDelete = self.categoryArray?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(categoryForDelete)
                }
            } catch {
                print("Delete error \(error)")
            }
        }
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let category = categoryArray?[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = category?.name ?? "Empty list"
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.todoListSegueIdentifire, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.todoListSegueIdentifire{
            let dectinotionVC = segue.destination as! TodoListVC
            
            if let indexPath = tableView.indexPathsForSelectedRows?.first{
                dectinotionVC.selectedCategory = categoryArray?[indexPath.row]
            }
        }
    }
    
}

