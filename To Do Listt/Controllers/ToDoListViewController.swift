//
//  ViewController.swift
//  To Do Listt
//
//  Created by Akki Suju on 25/03/18.
//  Copyright © 2018 Akki Suju. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


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
        
        tableView.separatorStyle = .none
        
    }
    
    
    /* Here we are doing/setting so many things
     within the Navigation Bar of our
     ToDoListViewController, such as -
     
     1. The colour of the bar as per the colour
        of the Category Item.
     2. The tile of the View Controller as per
        the name of the clicked Category.
     3. Background colour of the Search Bar, which
        is by-default grey, as per the colour of
        the Category
     
     navigationController is a default property
     that belongs to Navigation Controller.  If the
     View Controller is embedded in a Navigation
     Controller, then this property allows you to
     access the Navigation Controller.  This
     property is nil if the View Controller is
     not embedded inside a navigation controller.
     
     One imp. thing to note here is that we are not
     putting this code, to set the Navigation Bar
     colour, inside viewDidLoad method, rather we
     have used another imp method from the UI View
     Controller's life-cycle, which is - viewWillAppear.
     
     Just because the View has been loaded up
     does not mean that it has been embedded in
     Navigation Controller too.  It's very much
     possible that when our View is getting stacked
     on the Navigation Controller, right at that
     time the viewDidLoad method gets called, which
     can result the crash.
     
     Therefore, viewWillAppear is the right place
     to place this code that will set the colour
     of the Navigation Bar.
     */
    
    override func viewWillAppear(_ animated: Bool)
    {
        if let colourHex = selectedCategory?.colour
        {
            /* First of all, we are checking if the
             Navigation Controller is been initialized or
             not.  If yes, then store its reference in
             navBar variable, and if not, then throw an error.
             
             Now, what is this GUARD?  It's is very much
             similar to Optional Binding (the IF LET
             statement), but better to use in that case,
             when you don't have to do anything special,
             if the condition evaluates to False.
             
             However, IF LET should be used, when you want
             to do something even with the False condition.
             And of course, for False situation ELSE part
             is used.
             
             So, when you have to define something in ELSE
             part also, use IF LET; otherwise, use GUARD.
             Guard also uses Else part, but just to throw
             error. */
            
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist!")}
            
            
            
            /* TITLE is a default variable that
             represents the view that the current
             controller manages.  Using it we can set the
             title of the View.
             
             So, here we are setting the title of the
             ToDoListViewController, which is by-default
             set as - To Do List, same to the clicked
             Category's name.
             
             Also, for obivious reasons, it's safe to
             do forced-unwrap the selectedCategory. */
            
            title = selectedCategory!.name
            
            navBar.barTintColor = UIColor(hexString: colourHex)
            
            
            /* Here we are setting the colour of navigation
             items and bar button items in contrast with
             the applied background colour (or we can say,
             in contrast to the selected Category colour.)
             
             Using tintColor property we can set the colour
             of navigation items and bar button items.  And
             the ContrastColorOf is from the Chameleon
             Framework, which we have used even below inside
             cellForRowAt method.
             
             But before running the app, we will have to
             change the colour of the Add Button (Bar
             Button Item) to DEFAULT through the
             Main.storyboard, which we have set to white,
             when were setting up this button. */
            
            navBar.tintColor = ContrastColorOf(UIColor(hexString: colourHex)!, returnFlat: true)
            
            
            /* Here we are setting the colour (contrast
             colour) of the Title of our View or
             Navigation Bar, with the help of an
             attribute of Navigation Controller, named -
             largeTitleTextAttributes.
             
             It is of type NSAttributedStringKey that
             display attributes for the bar's large
             title text, and expects a dictionary value.
             */
            
            navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(UIColor(hexString: colourHex)!, returnFlat: true)]
            
            
            /* Here we are setting the Search Bar colour
             as per the clicked Category's colour. */
            
            searchBar.barTintColor = UIColor(hexString: colourHex)
        }
    }
    
    
    
    /* This is one more method from the life-cycle of
     UI View Controller, and in this method we are
     setting the Nav Bar color, and the colour of
     the Nav Bar items (like back button, add button)
     to their default colour.
     
     The reason for doing so is, when we click on the
     back button to go to the Category View, the colour
     scheme of the Navigation Bar (of
     ToDoListViewController) also gets carried away, and
     gets implemented on the Navigation Bar of the
     Category View.
     
     This method gets called when the View is just about
     to be removed, therefore, is the right place where
     we can set the colour of the Navigation Bar back to
     the original so that the original colour gets
     carried away to the Category View Controller.*/
    
    override func viewWillDisappear(_ animated: Bool)
    {
        guard let originalColour = UIColor(hexString: "1D9BF6") else{fatalError()}
        
        /* Now here we are not Guarding this statement
         unlike we did above, inside viewWillAppear
         method, because here we are at that point
         when the view is going to disappear, and by
         this time of course the Navigation Bar would
         have been initialized. */
        
        navigationController?.navigationBar.barTintColor = originalColour
        
        navigationController?.navigationBar.tintColor = FlatWhite()
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: FlatWhite()]
        
    }
    
    
    
    /* Note:
     The above two methods - viewWillAppear and
     viewWillDisappear, are basically used to set
     and reset the Navigation Bar colour.  So, the
     code is some sort of repetitive.
     
     Angela has defined a common method for this
     colour setting work, and that method she has
     called in both these methods.  However, what
     Angela has done is a good programming approach,
     but I find it a little complex, therefore I am
     not doing any such modifications in my code.
     
     To see Angela's code, please see the video -
     Updating the UI of Navigation Bar (Section 19,
     Lecture 274, at 23rd minute.). */
    
    
    
    
    
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
            
            /* Here we are giving colour to the sub-list
             items on the basis of the colour of their
             main Category.
             
             But, as we want to give the items in our
             ToDoListViewController a gradient effect,
             therefore, we are appending the darken() method
             to it.
             
             The darken() method takes a CGFloat value to
             decide the darkness.  The min CGFloat value
             can be 0 and max value can be 1.  And the
             
             Here we are deciding the darkness of the colour
             on the basis of the row no.  Initial rows will
             be lighter and final rows will be darker.
             
             This is the general form of the statement-
             
             let color = <initial expr.>.darken(byPercentage: CGFloat)
             
             But we have converted it into the below as per our
             requirement
             
             Two more thing to mind here-
             1. we are doing forced unwrapping for
             toDoItems, because we already have done
             Optional Binding for it above, so, it's safe
             here to go with forced-unwrapping.
             
             2. we have converted indexPath.row and
             toDoItems.count into CGFloat individually, and
             then divided them.  However, we could have
             divided them, and then got converted into
             CGFloat.  But the reason of not doing so is
             well explained in video - Creating Gradient
             Flow Cells (Section 19, Lecture 273, at 8.30
             minutes)
             */
            
            if let color = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(toDoItems!.count))
            {
                cell.backgroundColor = color
                
                
                /* One more method from the Chameleon Framework
                 to give the item text a contrasting colour as
                 compared to the row's background colour. */
                
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                
            }
            
            
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



