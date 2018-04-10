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
         therefore, dealing it with do-catch block. */
        
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

