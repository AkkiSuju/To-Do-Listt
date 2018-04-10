//
//  CategoryViewController.swift
//  To Do Listt
//
//  Created by Akki Suju on 04/04/18.
//  Copyright © 2018 Akki Suju. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift


class CategoryViewController: UITableViewController
{
    /* Here we are creating a Realm object i.e.
     initializing Realm.  As we know that creating
     a Realm object may throw an error, but because
     we have initialized it even before in
     AppDelegate file, therefore, it's absolutely
     fine to implicitly unwrap the try rather than
     dealing with it within do-catch block as it
     is mentioned in it's documentation too. */
    
    let realm = try! Realm()
    
    /* Here we are creating a variable of Results
     type that will contain the Categories stored
     in Realm DB.
     
     We have declared it optional because we are
     not initializing it here.
     
     Results is an auto-updating container
     type in Realm, which is a sort of array,
     dictionary, list etc, and gets returned when
     we query the the Realm DB.
     */
    
    var categories: Results<Category>?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        loadCategories()

        
    }
    
    
    
    /********************************/
    
    //MARK: Table View Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        /* This below statement is an example of Nil
         Coalescing Operator.
         
         We are saying here that if categories
         is not NIL, which it could be because it's an
         optional, then return the count of Categories;
         and if it's NIL, then just return 1. */
        
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        /* Here again we have used the Nil Coalescing
         Operator. */
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet!"
        
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
         a row.  Still, bcz it's an Optional therefore
         we are blending it with IF statement.
         */
        
        if let indexPath = tableView.indexPathForSelectedRow
        {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    
    /********************************/
    
    //MARK:  Data Manipulation Methods
    
    /* this user-defined method is to save new categories.
     If have any doubt on the below set of code, then plz
     go through the Realm topic. */
    
    func save(category: Category)
    {
        do
        {
            try realm.write
            {
                realm.add(category)
            }
        }
        catch
        {
            print("Error saving category: \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    
    /* This is the user-defined method to retrieve the
     data i.e. categories from the persistent store i.e.
     Realm so that we could display that data in our
     Table View. */
    
    func loadCategories()
    {
        /* Here we are fetching all the items (Categories)
         from the Realm database. */
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    
    
    
    /********************************/
    
    //Mark: Add new categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            
            newCategory.name = textField.text!
            
            
            /* While using Core Data, we need to append
             the newly added category to the list of
             Categories.  But, in case of Realm, the
             Results data-type is auto-updating container,
             therefore, we don't need the below statement,
             hence we have commented out it.
            
             self.categories.append(newCategory)
             */
            
            
            /* Calling the SAVE method and passing the
             newCategory as a value to it. */
            
            self.save(category: newCategory)
        }
        
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
    }
    

   
    
    
}
