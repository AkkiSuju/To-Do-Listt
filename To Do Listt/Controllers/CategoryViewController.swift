//
//  CategoryViewController.swift
//  To Do Listt
//
//  Created by Akki Suju on 04/04/18.
//  Copyright © 2018 Akki Suju. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


/* We are inheriting our class from the
 SwipeTableViewController class. */

class CategoryViewController: SwipeTableViewController
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
        
        // this is to remove the row lines
        tableView.separatorStyle = .none
        
        loadCategories()
        
    }
    
    
    
    /********************************/
    
    //MARK: Table View Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        /* This below statement is an example of Nil
         Coalescing Operator.  This is also called
         Optional Chaining.
         
         We are saying here that if categories
         is not NIL, which it could be because it's an
         optional, then return the count of Categories;
         and if it's NIL, then just return 1. */
        
        return categories?.count ?? 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        /* Here we are creating a variable (cell) of
         type of our super class i.e.
         SwipeTableViewController.  We are doing this
         so that our cell of CategoryViewController
         inherit the swipe effect from the super class.
         
         If have any doubt that what is happening here,
         please refer to the video - Inheriting from
         SwipeTableViewController (Section 19, Lecture
         269, somewhere at 8.40 minutes)
         */
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        /* Here again we have used the Nil Coalescing
         Operator. */
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet!"
        
        
        /* Here we are setting random colours for our
         rows.  This method comes from the Chameleon
         Framework, and we came to know about it by
         going through the documentation available
         on GitHub/CocoaPods.
         
         We even could have a very simple statement as
         given below to apply the random colour -
         
         cell.backgroundColor = UIColor.randomFlat
         
         But, the problem with this above statement is,
         it generates a random colour for our rows that
         keeps on changing after every re-load.  To keep
         the colour unchanged for a row, we need to
         persist it i.e. store it in our DB, and for that
         we need to get colour's hex-value.
         
         We are grabbing the hex-value of the colour
         below, inside addButtonPressed method, and
         retrieving that here to implement on the cell.
         
         Here we are doing Optional Chaining that says,
         if CATEGORIES is not NIL then grab the colour
         (hex-value), and apply on the cell; else, use
         the default colour (1D9BF6), which we have
         explicitly defined here, on the cell.
         */
        
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].colour ?? "1D9BF6")
        
        /* Don't bother about the too many exclamation
         marks in the statement; they all are the result
         of suggestions provided by Xcode, and I think
         doing force-unwrapping here is safe. */
        
        cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: (categories?[indexPath.row].colour)!)!, returnFlat: true)
        
        
        
        /* Note:
         For the above three statements, Angela has
         used this below block of code isntead.  I haven't
         used it because there was too much and imp to
         explain about the above statements.  However,
         I would prefer Angela's code if ever i create
         this app for commercial or professional
         purpose.
         
         Angela's code is -
         
         if let category = categories?[indexPath.row]
         {
         cell.textLabel?.text = category.name
         
         guard let categoryColour = UIColor(hexString: category.colour) else {fatalError()}
         
         cell.backgroundColor = categoryColour
         
         cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
         }
         
         */
        
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
    
    
    
    /* This is also a user-defined method that we have
     defined inside SwipeTableViewController file for
     performing delete operations.
     
     Here we are simply overriding that method and
     putting a relevant code.*/
    
    override func updateModel(at indexPath: IndexPath)
    {
        if let categoryForDeletion = self.categories?[indexPath.row]
        {
            do
            {
                try self.realm.write
                {
                    self.realm.delete(categoryForDeletion)
                }
            }
            catch
            {
                print("Error deleting category: \(error)")
            }

            //tableView.reloadData()
        }
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
            
            
            /* Here we are storing the hex value of the
             colour obtained by the randomFlat method.
             This colour value will be persisted when
             we call the SAVE method below. */
            
            newCategory.colour = UIColor.randomFlat.hexValue()
            
            
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


