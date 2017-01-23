//
//  AppDelegate.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-08-22.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    // Instanciate the CoreDataStack
    lazy var coreDataStack = CoreDataStack(modelName: "Model")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // get a reference to the first view controller...
        guard let navController = window?.rootViewController as? UINavigationController, let viewController = navController.topViewController as? ListeDeNouillesVC else { return true }
        
        // ... and pass the Core Data Context to it (dependency injection pattern)
        viewController.managedContext = coreDataStack.managedContext
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        coreDataStack.saveContext()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        coreDataStack.saveContext()
    }
    
}

