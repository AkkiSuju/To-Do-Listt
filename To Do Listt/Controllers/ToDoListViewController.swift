//
//  ViewController.swift
//  To Do Listt
//
//  Created by Akki Suju on 25/03/18.
//  Copyright © 2018 Akki Suju. All rights reserved.
//

import UIKit
import RealmSwift


/* We are inheriting our class from the
 SwipeTableViewController class. */

class ToDoListViewController: SwipeTableViewController
{
    
    /* Here we are creating a variable of Results
     type that will contain the Items stored
     in Realm DB.
     
     To know more, please refer to the
     CategoryViewController.
     */
    
    var toDoItems: Results<Item>?
    
    
    //creating a Realm object
    
    let realm = try! Realm()
    
    
    /* Here we are declaring a variable of type
     Category.  This is to store the category clicked
     by user and passed by the segue (inside
     CategoryViewController) to
     ToDoListViewController.
     
     We have declared it optional because it will get
     the value only once user clicks a category/item
     and the segue gets performed.  Until then it
     remains empty.
     
     But once it gets value i.e. a category, then
     that's the time when we want to load all the
     items that are relevant to this category. For
     this we use a special keyword/method called
     didSet that gets executed once the variable
     gets a vlaue. */
    
    var selectedCategory : Category?
    {
        didSet
        {
            /* call to the loadItems method to fetch
             the data from the persistent store. */
            
           loadItems()
        }
    }
    
    
    // Linked Search Bar with the IBOutlet
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        
        
    }
    
    
    
    
    
    /********************************/
    
    //MARK: - Table View DataSource Methods
    
    
    /* Refer to WhatsApp coding to get explanation
     for the below two methods. */
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int
    {
        return toDoItems?.count ?? 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell
    {
        
        /* Here we are creating a variable (cell) of
         type of our super class i.e.
         SwipeTableViewController. You can get rest of
         the explanation in CategoryViewController. */
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row]
        {
            cell.textLabel?.text = item.title
            
            
            //Using Ternary Operator to set checkmark
            
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else
        {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
        
    }
    
    
    
    
    /********************************/
    
    //MARK: - Table View Delegate Methods
    
    
    /* Refer to WhatsApp coding to get explanation
     for the below two methods.
     
     A little bit of explanation is as such, when
     user will click a row/item then this method will
     execute, and will put or remove checkmark on
     that row as a mark of completion or incompletion.
     */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath)
    {
        
        if let item = toDoItems?[indexPath.row]
        {
            do
            {
                try realm.write
                {
                    /* Here we are using not operator (!).
                     This will set the DONE property (we
                     have defined this property in ITEM
                     data file) for the current item just
                     to opposite of what it is already set.
                     It means, if DONE property is TRUE
                     then it will set to FALSE, and
                     vice-versa.
                     */
                    
                    item.done = !item.done
                    
                    
                    /* Instead of putting a checkmark on
                     the clicked item/row, if you need to
                     delete it, then use this below
                     statement.
                    
                     realm.delete(item)
                    */
                    
                }
            }
            catch
            {
                print("Error saving done status: \(error)")
            }
            
        }
        
        tableView.reloadData()

        
        /* By default, on selecting a row, it gets
         permanently selected until we click on
         another row, and also the background colour
         changes.
         
         This statement will select the row just for a
         moment on clicking, and then will bring it
         back to normal. */
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    /********************************/
    
    //MARK: - Add new items


   
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
       
        /* Creating a variable of UITextField type, and the
         reason is given a little below. */
        
        var textField = UITextField()
        
        /* When user clicks on the Add New Item button,
         we want to open a pop-up or a UI Alert Controller
         containing a Text Field to add a new item that we
         could add to our itemArray. */
        
        let alert = UIAlertController(title: "Add New Item",
                                      message: "", preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: "Add Item", style:
        .default) { (UIAlertAction) in
            
            
            /* Because selectedCategory is an Optional,
             therefore, doing Optional Binding to check
             if it contains a value. */
            
            if let currentCategory = self.selectedCategory
            {
                /* If the Selected Category is not Nil,
                 then we will add the newly added item
                 to the Realm Database with the help of
                 below block of code. */
                do
                {
                    try self.realm.write
                    {
                        // Creating a varible of Item class type
                        let newItem = Item()
                        
                        newItem.title = textField.text!
                        
                        /* It will store the current date in the
                         dateCreated property, when the new item is
                         added.
                         
                         And with the help of this property, later
                         we can sort our items' list date-wise. */
                        
                        newItem.dateCreated = Date()
                        
                        /* Adding the new item, entered by user, to
                         the Current Category. */
                        currentCategory.items.append(newItem)
                    }
                }
                catch
                {
                    print("Error saving new item: \(error)")
                }
                
                
            }
            
            self.tableView.reloadData()
        }
        
        
        /* This is to put text field inside pop-up window.
         The method will provide you a placeholder for its
         argument.  Simply select the placeholder and press
         Enter to enter a Closure.
         
         It will provide two placeholders - UITextField and
         code.  Give a name to the UITextField (alertTextField
         in this case).  Delete the code placeholder and give
         your own code. */
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            
            
            /* Because the alertTextField has a scope just
             within this closure therefore we have declared
             a variable of TextField type above, and here
             storing the value of alertTextField to it, so
             that we can use it anywhere within
             addButtonPressed method. */
            
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    /********************************/
    
    //MARK: - Model Manupulation Method
    
    
    // User-defined method to load items
    
    func loadItems()
    {
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    
    
    /* This is also a user-defined method that we have
     defined inside SwipeTableViewController file for
     performing delete operations.
     
     Here we are simply overriding that method and
     putting a relevant code.*/
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = toDoItems?[indexPath.row]
        {
            do
            {
                try realm.write
                {
                    realm.delete(item)
                }
            }
            catch
            {
                print("Error deleting Item: \(error)")
            }
        }
    }
    
}




/*******************************/

//MARK: Extension fo Search Bar methods

/* Extending our class, and adopting UISearchBarDelegate
  to use Search Bar delegate methods. */

extension ToDoListViewController: UISearchBarDelegate
{
    /* This delegate method will be called when we type
     something in the search bar and hit Enter/Search, to
     find out an item(s) in the item-list.
     */

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        /* The FILTER method returns a Results type containing
         all the objects matching the given predicate i.e.
         "title CONTAINS[cd] %@".
         
         We are sorting the filtered result/items as per the
         date the items were created.
         */
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
    }

    /* This delegate method gets called whenever we type
     something inside the search bar, even when we click
     the cross button inside search bar.

     So, we are using this method so that when user clears
     his search criteria, all the items in the list get
     displayed on the screen.

     We coding this method such a way that when user clicks
     the cross button, it re-loads the data. */

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        /* When user clicks the cross button, all the
         characters will be wiped out from the search bar.
         So, the count of the characters will be zero. */
        
        if searchBar.text?.count == 0
        {
            loadItems()

            /* When user clicks the cross button to cancel
             his search criteria, the whole item list appears.
             But, keyboard remains visible, and the cursor
             still blinks inside the search bar.  To get over
             this, we use the below block of code.

             Whenever we writing methods to affect user
             interface, we tend to want it to happen in the
             fore-ground. Such as here we want to remove the
             on-screen keyboard and the cursor from within
             the search bar.  In order to do that, we have
             to tap into the DispatchQueue, which manages
             the execution of work items.  It assigns the
             works to different threads.

             Here we are asking it to grab us the main
             thread where we will update the user-interface
             elements.  So, essentially we are asking the
             DispatchQueue to get the main queue and then run
             the resignFirstResponder method on the main
             queue.

             resignFirstResponder method takes over the
             control from an element of being the first
             responder to the user, and pushes it back
             from the front, not appearance-wise but
             priority-wise.  So, because Search Bar won't
             be the first responder to the user on the
             invocation of this method, therefore, the
             Keyboard and the cursor will disappear.
             */

            DispatchQueue.main.async
            {
                searchBar.resignFirstResponder()
            }


        }
    }
}



