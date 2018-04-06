//
//  ViewController.swift
//  To Do Listt
//
//  Created by Akki Suju on 25/03/18.
//  Copyright © 2018 Akki Suju. All rights reserved.
//

import UIKit
import CoreData


class ToDoListViewController: UITableViewController
{
    
    /* Declaring an array of type Item.  Item is
     the Entity that we have created while setting
     up our core data i.e. To_Do_Listt.xcdatamodeld
     file.  This file is stored in Data Model folder.
     */
    
    var itemArray = [Item]()
    
    
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
    
    
    /* What we doing with this below statement is,
     we are getting a reference (context) of
     persistentContainer i.e. our SQLite database,
     and saving it in a variable that too we have named
     as context.
     
     And how we are doing this; we are tapping into
     the UIApplication class, getting its shared
     singleton object that communicates with the
     current app as an object.
     
     Then we are tapping into its delegate that is
     knows as App Delegate, and down-casting it into
     our AppDelegate class so that we get able to
     access the persistentContainer property of
     AppDelegate class, and then finally could grab
     its viewContext.
     */
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    // Linked Search Bar with the IBOutlet
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        /* This is to print the path of the location
         where our data is going to be soted for the
         current app using Core Data. */
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
        /* Declaring ourselves as the delegate of the
         Search Bar.
         
         There is one more way of declaring ourselves
         i.e. our class as the delegate, and that is,
         drag-n-drop the UI Element (with Ctrl button
         pressed of course) to the View Controller
         icon on top of the View Controller; and once
         you release the element, a small pop-up will
         appear, where you have to select DELEGAT option.
         
         In such case you don't even need to link the
         UI Element with the IBOutlet. */
        
        searchBar.delegate = self
        
        
        
        
    }
    
    
    
    
    
    /********************************/
    
    //MARK: - Table View DataSource Methods
    
    
    /* Refer to WhatsApp coding to get explanation
     for the below two methods. */
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int
    {
        return itemArray.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell
    {
        /* As we have mentioned in the begining of
         the topic that if we use Table View
         Controller then we don't have to link the
         IBOutlets.  tableView is a varibale set by
         default by the Table View Controller*/
        
        let cell = tableView.dequeueReusableCell(withIdentifier:
            "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        
        //Using Ternary Operator to set checkmark
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    
    
    
    
    /********************************/
    
    //MARK: - Table View Delegate Methods
    
    
    /* Refer to WhatsApp coding to get explanation
     for the below two methods.
     
     A little bit of explanation is as such, when
     user will click a row then this method will
     execute, and will put or remove checkmark on
     that row. */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath)
    {
        
        /* Here we are using not operator (!).
         This will set the DONE property (we have
         defined this property in ITEM entity) for the
         current item just to opposite of what it is
         already set.  It means, if DONE property is
         TRUE then it will set to FALSE, and vice-versa.
         
         Then with the help of this property we can
         check and uncheck the checkmark on a cell/row
         inside cellForRowAtIndexPath method above.
         */
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row]
            .done
        
        
        /* This below commented statement is just an
         example to show that how we can perform Update
         operations on our persistent store i.e. DB.
         
         So, the idea is, if user clicks on an item, it
         will be marked with a text as completed,
         replacing the actual item.
        
         itemArray[indexPath.row].setValue("Completed", forKey: "title")
        
         */
        
        
        
        /* These two commented statements below are
         used to show that how a DELETE operation is
         performed on a persistent store.
         
         The sequence of the statements matters a lot.
         Deletion of a record from the DB should be done
         before, becuase if you delete the item from the
         array before, then the row/index on which the
         DELETE operation will be performed won't be
         existing, and the app will crash.
        
         itemArray.remove(at: indexPath.row)
        
         context.delete(itemArray[indexPath.row])
        */
        
        
        
        /* The above statement will set the DONE
         property, and accordingly checkmark wil be
         visible or invisible on a row in Table View.
         
         But we have to save that status of DONE property
         in our database too, therefore, here we are
         calling the saveItems method to save the
         DONE property in the persistent store.
         */
        
        saveItems()
        
        
        
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
            
            
            /* Here we are storing the context/reference
             of Item entity in a variable newItem so that
             we could use this variable to take user input
             i.e. new list items.
             
             We know that Item is an entity created in
             our core data file named as -
             To_Do_Listt.xcdatamodeld.  But there is one
             more thing to note that Item (or an entity)
             is of type NSManagedObject, which is equivalent
             to a row of your DB table.  So, every single
             row of your table will be an NSManagedObject.
             */
            
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            
            
            /* Here we are setting the DONE property to
             false of any newly added item. */
            
            newItem.done = false
            
            
            /* This is to se the parent category of the
             newly added item.  We got this parentCategory
             property/attribute by setting a relationship
             between the Category and Item entities, and
             named it as parentCategory for Item entity.
             
             Remember that the relationship between two
             entities will have different names for both
             the entities.  For Category entity we have
             named it as items.
             
             For any doubt, please refer to the video -
             How to Create Relationship Graphs in Core
             Data (Section 19, Lecture 258).
             */
            
            newItem.parentCategory = self.selectedCategory
            
            
            // adding the new item to the array/list
            
            self.itemArray.append(newItem)
            
            
            /* Calling the saveItems method to save the
             itemArray to the plist file. */
            
            self.saveItems()
            
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
    
    
    /* Defining a use defined method that will save the
     itemArray to our persistent store. */
    
    func saveItems()
    {
        do
        {
            /* Here we calling this method that tends to
             throw error, and it basically saves what's
             currently inside our temp/staging area, to
             our persistent store.
             
             One imp thing to point out here that out of
             all four CRUD operations, READ is the only
             operation when we don't need to call this below
             method; otherwise, after every other CRUD
             operation, we will call this method to apply
             the changes in our DB too.
             
             To understand it better, please go through the
             topic - Core Data.
             */
            
            try context.save()
        }
        catch
        {
            print("Error saving context: \(error)")
        }
        
        /* after adding new item, we are reloading the
         table to see the new item. */
        
        tableView.reloadData()
        
    }
    
    
    /* User-defined method to load items.
     
     This is something similar that we have done
     in loadCategories() method, inside
     CategoryViewController.  But here we are using
     the NSFetchRequest as a parameter of the method,
     because the Search Bar method also calling this
     method with an argument as request.
     
     In this method we have used an external parameter
     (with) and internal parameter (request), and also
     have provided a default value to the parameter.
     
     As per the requirement, we have used one more
     parameter of type NSPredicate, and to set its
     default value as NIL, we declared it of type
     optional.
     
     The benefit of giving a default value is, if the
     method is called without an argument, even then
     Xcode won't give you an error, instead it will
     provide the default value to the method.
     
     As we have called this method above (inside
     viewDidLoad method) without any argument, because
     at that stage there is no point of making a request
     (a kind of personalized/conditional call as we have
     done in Search Bar method), still Xcode has executed
     the call.
     */
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil)
    {
        /* To know more about NSPredicate, please refer to
         the EXTENSION below.
         
         Here we simply querying our DB on the basis of the
         selected/tapped category, and will load the items
         related with that category. */
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        
        /* Because the predicate parameter above is of
         optional type, therefore, we are doing optional
         binding to deal with it.
         
         Other noticable thing in the below block is
         NSCompoundPredicate, which is a specialized
         predicate that can contian multiple predicates.
         Here we have to deal with two predicates - 1st is
         the categoryPredicate, and 2nd is the predicate
         that is received from the Search Bar method inside
         the EXTENSION below.
         
         If the call to the loadItems method comes from the
         Search Bar method, then the IF block will get
         executed, because predicate will be passed only
         from that method; otherwise, the ELSE block will
         be executed.
         
         */
        
        if let additionalPredicate = predicate
        {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }
        else
        {
            request.predicate = categoryPredicate
        }
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//
//        request.predicate = compoundPredicate
        
        do
        {
            itemArray = try context.fetch(request)
        }
        catch
        {
            print("Error fetching data from the context: \(error)")
        }
        
        tableView.reloadData()
    }

    
}




/*******************************/

//MARK: Extensions fo Search Bar methods

/* Extending our class, and adopting UISearchBarDelegate
  to use Search Bar delegate methods. */

extension ToDoListViewController: UISearchBarDelegate
{
    /* This delegate method will be called when we type
     something in the search bar and hit Enter/Search.
     */
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        
        /* In order to query objects using Core Data we
         need to use NSPredicate. It represents conditions
         that are used to constrain a search either for a
         fetch or for in-memory filtering.
         
         There is a NSPredicate cheat-sheet (pdf file)
         within the iOS folder, to know more about the
         keywords and symbols used within NSPredicate.
         It's really useful if you want to enhance your
         limits of querying Core Data database.
         
         This is the general form of the below method-
         let predicate = NSPredicate(format: String, args: CVarArg...)
         
         So, what actually is happening here, when we hit
         the search button, then whatever we have entered
         inside the search bar at that time point is going
         to be passed into the %@ of this method.  Then we
         are comparing the TITLE with the value contains in
         %@ sign.
         
         [cd] makes the string case and diacritic
         insensitive.  To know more please follow
         this link - http://nshipster.com/nspredicate/
         */
        
         let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        
        /* Here we are sorting the query result, and then
         adding it to our request.   Because sortDescriptors
         expects an array of sort descriptor, therefore, we
         have enclosed the sort descriptor inside a square-
         bracket. */
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        

        /* Now, calling the loadItems method, and passing
         the request and the predicate to the method so that
         the items get loaded on the basis of the
         current request i.e. the value inside search bar.
        */
        
        loadItems(with: request, predicate: predicate)
        
        
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



