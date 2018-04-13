//
//  SwipeTableViewController.swift
//  To Do Listt
//
//  Created by Akki Suju on 11/04/18.
//  Copyright © 2018 Akki Suju. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Setting the row/cell height
        tableView.rowHeight = 80.0
    }
    
    
    
    
    /************************************/
    
    // MARK: Table View Data Source Methods
    
    
    /* The cells in the sub-class will be created
     on the basis of this method i.e. by giving a
     call to this method. */
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        /* As we have mentioned in the begining of
         the topic that if we use Table View
         Controller then we don't have to link the
         IBOutlets.  tableView is a varibale set by
         default by the Table View Controller */
        
        /* We have down-casted the cell to Swipe Table
         View Cell so that could implement the swipe
         effect on the cell.
         
         You will learn about all this by going through
         the documentation of Swipe Cell Kit CocoaPods.*/
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        
        /* Declaring our class as the delegate of
        SwipeTableViewCell class. */
        
        cell.delegate = self
        
        return cell
    }

    
    
    
    
    
    /******************************************/
    
    // MARK: SwipeTableViewCell delegate methods
    
    
    /* We have copied this delegate method right from the
     documentation of the SwipeCellKit (on CocoaPods.org).
     
     It will allow user to swipe the row/item till mid-way
     that he wants to delete, and make the DELETE icon
     visible. On clicking the icon, this method gets
     triggered, and the item gets deleted.
     
     If you read the code carefully then will see that the
     1st statement says that the swipe orientation should
     be right i.e. cell should be swiped from right-to-left.
     
     In another block (SwipeAction), you have to give your
     own code that will be triggered when user clicks on
     the DELETE icon that appears while swipping the cell.
     
     For the 3rd statement we will have to store a delete
     or trash image in our app as a delete icon.  We can
     use any relevant image, but it would be better if we
     get it right from the SwipeCellKit example on the GitHub.
     */
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]?
    {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            /* This is not the default code, rather we have
             created it for deleting the swiped category */
            
            /* We can't delete a row of a subclass right in
             the superclass, because superclass provides only
             the functionality to the subclass, but it
             doesn't perform any function explicitly for the
             subclass.
             
             So, we have created another method for deleting
             purpose, at the bottom of this file, and calling
             that method here.  We are also passing the index
             no of the row that is marked/swiped for deletion.
             */
            
            self.updateModel(at: indexPath)
            
        }
        
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    
    
    
    /* This is another delegate method that we copied form
     the documentation of the SwipeCellKit (on CocoaPods.org)
     
     It allows the user to delete the row by swiping it
     completely.
     
     We haven't done any changes to this default code,
     apart from commenting one statement.  And the reason
     is given insdie the block. */
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        
        
        /* We have commented this default statement
         because we are not intrested in implementing
         this feature at the moment.
         
         To know more about it you can read the
         documentation. */
        
        // options.transitionStyle = .border
        
        return options
    }
    
    
    
    
    
    
    /************************************/
    
    // MARK: Data manipulation method
    
    
    
    /* We have created this method to perform delete
     operatios, but we don't have any code inside this
     method.  We only have the row index no. that is
     been swiped for deletion.
     
     It's just a sort of template that we will use to
     override in the sub-class to update the Data Model
     or basically to perform delete operation.
     */
    
    func updateModel(at indexPath: IndexPath)
    {
        //
    }
    

}
