//
//  CategoryVC.swift
//  Todoey
//
//  Created by Владислав Воробьев on 16.07.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryVC: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categoryArray = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    // MARK: - Add Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new todoy category", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add category", style: .default) { action in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            self.saveCategories()
            
        }
        alert.addTextField { alertFT in
            alertFT.placeholder = "Create new category"
            textField = alertFT
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    // MARK: - Data Methods
    
    func saveCategories(){
        do {
            try context.save()
            print("Succes Save")
        } catch {
            print("Save error \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(for request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do{
            categoryArray = try context.fetch(request)
            print("Succes Load")
        } catch {
            print("Error in fetch data \(error)")
        }
        tableView.reloadData()
    }
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.categoryCellIdentifire, for: indexPath)
        let category = categoryArray[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = category.name
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
                dectinotionVC.selectedCategory = categoryArray[indexPath.row]
            }
        }
    }
    
}

