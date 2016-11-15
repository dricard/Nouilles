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
   lazy var coreDataStack = CoreDataStack(modelName: "Nouilles")
   
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      
      guard let navController = window?.rootViewController as? UINavigationController, let viewController = navController.topViewController as? ListeDeNouillesVC else { return true }
      
      // pass the Core Data Context to the first View Controller (dependency injection)
      viewController.managedContext = coreDataStack.managedContext
      
      return true
   }
   
   func applicationWillResignActive(_ application: UIApplication) {
   }
   
   func applicationDidEnterBackground(_ application: UIApplication) {
      coreDataStack.saveContext()
   }
   
   func applicationWillEnterForeground(_ application: UIApplication) {
   }
   
   func applicationDidBecomeActive(_ application: UIApplication) {
   }
   
   func applicationWillTerminate(_ application: UIApplication) {
      coreDataStack.saveContext()
   }
   
   
}

