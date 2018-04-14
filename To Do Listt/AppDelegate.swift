//
//  AppDelegate.swift
//  To Do Listt
//
//  Created by Akki Suju on 25/03/18.
//  Copyright © 2018 Akki Suju. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        
        /* Creating a Ralm object i.e. initializing
         Realm, and because it could throw an error,
         therefore, dealing it with do-catch block.
         
         In Swift, when we initialize a variable/object,
         but never use it, then rather than giving it
         a name, we simply replace with underscore (_).
         
         The Realm object we are creating here is not
         going to use anywhere within this file.  We
         are initializing it just to ensure that all
         is well while setting it up. */
        
        do
        {
            _ = try Realm()
        }
        catch
        {
            print("Error initializing new Realm: \(error)")
        }
        
        
        // this is just to get the path of Realm data file.
        
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        return true
    }

}

