//
//  Category.swift
//  To Do Listt
//
//  Created by Akki Suju on 08/04/18.
//  Copyright © 2018 Akki Suju. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object
{
    @objc dynamic var name: String = ""
    
    /* Here we are setting up a forward relationship.
     
     In Core Data, we don't have to do relationship
     forward and backward explicitly.  However, in
     Realm we do it explicity both ways.
     
     List is a sort of collection or container type
     in Realm used to define to-many relationships.
     So, we are creating a variable, which is
     basically a collection (List) of ITEM class type.
     
     This is very much similar to creating an array.
     
     This statement/relationship says that inside each
     Category there is a thing called items that points
     to a list of item objects. */
    
    let items = List<Item>()
}
