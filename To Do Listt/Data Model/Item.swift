//
//  Item.swift
//  To Do Listt
//
//  Created by Akki Suju on 08/04/18.
//  Copyright © 2018 Akki Suju. All rights reserved.
//

import Foundation
import RealmSwift


class Item: Object
{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    
    /* This is to set up the inverse relationship.
     It says that each item in the ITEM class has
     a parent category.
     
     The property items is the name of the relationship
     of the Category class.
     
     So, the parentCategory (the relationship name of
     the ITEM class) is related/connected to the
     items property of the Category class.
     */
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
