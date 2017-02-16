//
//  AppDelegate.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-08-22.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    // User notifications
    let center = UNUserNotificationCenter.current()
    var userGrantedNotificationsPersmission = false
    let permissionKey = "permissions"

    // Create a Timers object that will hold timers for
    // noodles. This will be passed along when needed
    // Note: not to be confused with the Timer class
    var timers = Timers()

    // Instanciate the CoreDataStack
    lazy var coreDataStack = CoreDataStack(modelName: "Model")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Insert sample data (which checks if data already exists)
        insertSampleData()
        
        loadPreferences()
        
        // get a reference to the first view controller
        guard let navController = window?.rootViewController as? UINavigationController, let viewController = navController.topViewController as? ListeDeNouillesVC else { return true }
        
        // set background color to the navigation bar
        navController.navigationBar.backgroundColor = NoodlesStyleKit.darkerYellow
        
        // pass the Core Data Context to it (dependency injection pattern)
        viewController.managedContext = coreDataStack.managedContext
        viewController.timers = timers
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        coreDataStack.saveContext()
        convertTimersToNotifications()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        coreDataStack.saveContext()
    }
    
    // MARK: - Utilities
    
    func insertSampleData() {
        
        // check if data exist already
        // this method will populate with sample data if the app is
        // launched with no data.
        let fetch: NSFetchRequest<Nouille> = Nouille.fetchRequest()
        fetch.predicate = NSPredicate(format: "name != nil")
        
        let count = try! coreDataStack.managedContext.count(for: fetch)
        
        if count > 0 { return }
        
        let path = Bundle.main.path(forResource: "SampleData", ofType: "plist")
        let sampleDataArray = NSArray(contentsOfFile: path!)! as! [[String:Any]]
        
        for dictionary in sampleDataArray {
            
            // Create the new noodle
            let newNoodle = Nouille(context: coreDataStack.managedContext)
            
            // Noodle data
            newNoodle.name = dictionary["name"] as? String
            newNoodle.brand = dictionary["brand"] as? String

            newNoodle.servingCustom = dictionary["serving_meal"] as? NSNumber
            newNoodle.servingSideDish = dictionary["serving_side"] as? NSNumber
            newNoodle.time = dictionary["cooking_time"] as? NSNumber
            newNoodle.rating = dictionary["rating"] as? NSNumber
            
            // default to prefer meal size servings
            newNoodle.mealSizePrefered = dictionary["prefer_meal_size"] as? NSNumber
            // default to number of serving of 1
            newNoodle.numberOfServing = 1
            // default to onHand
            newNoodle.onHand = dictionary["on_hand"] as? NSNumber
            
            // load default image
            let imageFile = dictionary["image"] as? String
            if let imageFile = imageFile {
                let image = UIImage(named: imageFile)
                if let image = image {
                    newNoodle.image = UIImagePNGRepresentation(image) as NSData?
                }
            }
        }
        
        // Save the context / new noodle to coredata
        do {
            try coreDataStack.managedContext.save()
        } catch let error as NSError {
            print("Could not save context in saveNoodleData() \(error), \(error.userInfo)")
        }
    }
    
    func loadPreferences() {
        // check if we have a dictionary to unarchive (we saved prefs before)
        if let _ = UserDefaults.standard.value(forKey: permissionKey) {
            userGrantedNotificationsPersmission = UserDefaults.standard.bool(forKey: permissionKey)
        } else {
            // no preferences found, default to false and ask permissions
            UserDefaults.standard.set(false, forKey: permissionKey)
            checkPermissions()
        }
    }
    
    func checkPermissions() {
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        center.requestAuthorization(options: options) {
            (granted, error) in
            guard error == nil else { return }
            
            if !granted {
                print("User denied access to notifications")
                UserDefaults.standard.set(false, forKey: self.permissionKey)
            } else {
                self.userGrantedNotificationsPersmission = true
                print("User granted notifications permissions")
                self.userGrantedNotificationsPersmission = true
                UserDefaults.standard.set(true, forKey: self.permissionKey)
            }
        }
    }

    func convertTimersToNotifications() {
        
    }
}

