//
//  CategoryViewController.swift
//  To Do Listt
//
//  Created by Akki Suju on 04/04/18.
//  Copyright © 2018 Akki Suju. All rights reserved.
//

import UIKit
import CoreData


/* Those statements whose comments are not given,
 and you have any doubt on them, then first go
 through the ToDoListViewController.swift file.*/


class CategoryViewController: UITableViewController
{
    // Creating an array of type Category entity.
    
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        loadCategories()

        
    }
    
    
    
    /********************************/
    
    //MARK: Table View Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        /* In ToDoListViewController file we have done
         this below thing slightly different way.  And
         the reason for that is, we have two attributes
         in Item entity (that we accessing in
         ToDoListViewController), but here we have only
         one attribute in Category entity, which is name.
         Therefore, we have done the required thing in
         only one statement here. */
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
    
    
    
    
    /******************************/
    
    //MARK: Table View Delegate Methods
    
    /* As we know that this method gets invoked when table
     cell (row) is clicked.  And we want to perform Segue
     on clicking the cell.
     
     The idea is, when user clicks a cell i.e. a
     category/item of his to-do-list, then a sub-list of
     items of that particular category should open on
     another screen.*/
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    /* This is the method that gets called just before
     the execution of performSegue method.  So, we will
     use this method to pass the information of selected
     cell i.e. category to the ToDoListViewController.
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let destinationVC = segue.destination as! ToDoListViewController
        
        
        /* indexPathForSelectedRow is an optional type,
         which means that there is a possiblity that no
         row is selected.  It's not possible here bcz we
         are only triggering out segue when user selects
         a row.  Still, bcz it's an optional therefore
         we are blending it with IF statement.
         */
        
        if let indexPath = tableView.indexPathForSelectedRow
        {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    
    
    /********************************/
    
    //MARK:  Data Manipulation Methods
    
    // this user-defined method is to save new categories
    func saveCategories()
    {
        do
        {
            try context.save()
        }
        catch
        {
            print("Error saving category: \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    
    /* This is the user-defined method to retrieve the
     data i.e. categories from the persistent store
     so that we could display that data in our Table
     View. */
    
    func loadCategories()
    {
        /* Now this is basically a Read operation of the
        CRUD methodology.

        Here we are fetching the data from our persistent
        store so that could display that on the Table View.

        And for that we are using a type called
        NSFetchRequest.  But we also need to mention that
        what kind of data NSFetchRequest will fetch,
        therefore, we need to specify a type for the
        NSFetchRequest type itself, and that type is
        CATEGORY.

        So, what exactly we doing here, declaring a var
        request of type NSFetchRequest<Category> and
        storing the value of Category.fetchRequest method
        inside it.
         */
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do
        {
            categories = try context.fetch(request)
        }
        catch
        {
            print("Error loading categories: \(error)")
        }
            
        tableView.reloadData()
    }
    
    
    
    
    /********************************/
    
    //Mark: Add new categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            
            newCategory.name = textField.text!
            
            self.categories.append(newCategory)
            
            self.saveCategories()
        }
        
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
    }
    

   
    
    
}
