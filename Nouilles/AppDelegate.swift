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
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    // User notifications
    let center = UNUserNotificationCenter.current()
    // We'll check if the user granted permissions or not at launch
    // He might have change the permissions in utilities, either way
    // so we need to check that each launch. If the user denied permission
    // we need to ask (politely) for permission because the timers won't work
    // otherwise. So this is to trigger a more extensive dialog to explain
    // the reasons for asking prior to have the system request permissions.
    var userDeniedPermission = false
    let permissionWasDeniedOnceKey = "permissions"
    let neverAskAgainKey = "neverAskPermissionsAgain"
    
    // Create a Timers object that will hold timers for
    // noodles. This will be passed along when needed
    // Note: not to be confused with the Timer class
    var timers = Timers()
    
    // Instanciate the CoreDataStack
    lazy var coreDataStack = CoreDataStack(modelName: "Model")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Insert sample data (this method checks if data already exists)
        insertSampleData()
        
        // Load preferences
        loadPreferences()
        
        // set notifications categories
        let notificationCategory = UNNotificationCategory(identifier: "com.hexaedre.nouilles", actions: [], intentIdentifiers: [], options: UNNotificationCategoryOptions())
        center.setNotificationCategories([notificationCategory])
        center.delegate = self
        
        // get a reference to the first view controller
        guard let navController = window?.rootViewController as? UINavigationController, let viewController = navController.topViewController as? NoodlesListVC else { return true }
        
        // Theme related: set background color to the navigation bar
        navController.navigationBar.backgroundColor = NoodlesStyleKit.darkerYellow
        
        // pass the Core Data Context to it as well as the timers object (dependency injection pattern)
        viewController.managedContext = coreDataStack.managedContext
        viewController.timers = timers
        viewController.shouldRequestPermission = willAskUserForPermission()
                
        return true
    }
    
    // When one or more timers are running and the app goes to the background
    // we need to convert those timers to timed notifications.
    func applicationDidEnterBackground(_ application: UIApplication) {
        coreDataStack.saveContext()
        convertTimersToNotifications()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        coreDataStack.saveContext()
    }
    
    // When the app returns from the background, we may have to
    // convert notifications back to timers or clear delivered notifications
    func applicationDidBecomeActive(_ application: UIApplication) {
        convertNotificationsToTimers()
    }
    
    // Here we take care of notifications that aren't in either the 'pending'
    // or the 'delivered' lists. This gets called when the user tapped the
    // notification itself to return the app to the foreground. In that
    // case the notification is cleared so it doesn't appear in the 'delivered'
    // list. We still need to clean up in those cases.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        for (id, thisTimer) in timers.timers {
            if response.notification.request.identifier == String(id) {
                thisTimer.secondsLeft = 0
                thisTimer.shouldRing = false
            }
        }
        completionHandler()
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
            newNoodle.glutenFree = dictionary["glutenFree"] as? NSNumber
            newNoodle.longNoodles = dictionary["longNoodles"] as? NSNumber
            
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
        if let _ = UserDefaults.standard.value(forKey: permissionWasDeniedOnceKey) {
            userDeniedPermission = UserDefaults.standard.bool(forKey: permissionWasDeniedOnceKey)
        } else {
            // no preferences found, default to false and ask permissions
            UserDefaults.standard.set(false, forKey: permissionWasDeniedOnceKey)
            UserDefaults.standard.set(false, forKey: neverAskAgainKey)
        }
        checkPermissions()
    }
    
    // Ask user for permission to set notifications (timers when app is in the
    // background).
    func checkPermissions() {
        let options: UNAuthorizationOptions = [.alert, .sound]
        center.requestAuthorization(options: options) {
            (userGrantedPermission, error) in
            guard error == nil else { return }
            
            if userGrantedPermission {
                print("User granted notifications permissions")
                self.userDeniedPermission = false
                // Also reset the userdefaults values
                UserDefaults.standard.set(false, forKey: self.permissionWasDeniedOnceKey)
                UserDefaults.standard.set(false, forKey: self.neverAskAgainKey)
            } else {
                print("User denied access to notifications")
                UserDefaults.standard.set(true, forKey: self.permissionWasDeniedOnceKey)
                self.userDeniedPermission = true
            }
        }
    }
    
    func willAskUserForPermission() -> Bool {
        if userDeniedPermission {
            // we only setup to ask permissions if it is currently denied
            let userDeniedPermissionOnce = UserDefaults.standard.bool(forKey: permissionWasDeniedOnceKey)
            let userAskedNeverToAskForPermissionsAgain = UserDefaults.standard.bool(forKey: neverAskAgainKey)
            return userDeniedPermissionOnce && userAskedNeverToAskForPermissionsAgain == false
        } else {
            return false
        }
    }
    
    
    // Timers can't run while the app is in the background,
    // so we convert to notifications set to fire when the
    // timer would have fired.
    func convertTimersToNotifications() {
        if timers.isNotEmpty() {
            if userDeniedPermission == false {
                for (id, thisTimer) in timers.timers {
                    let content = UNMutableNotificationContent()
                    content.title = .noodleNotificationTitle
                    content.body = .noodleNotificationMessage
                    content.sound = UNNotificationSound(named: "ringSound2.m4a")
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(thisTimer.secondsLeft), repeats: false)
                    let identifier = String(id)
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                    // timeInterval works to set the notification to fire at the right time...
                    // ...but nextTriggerDate() doesn't work as expected for convertNotificationsToTimers, see this SO thread:
                    // http://stackoverflow.com/questions/40411812/does-untimeintervalnotificationtrigger-nexttriggerdate-give-the-wrong-date
                    // So I'm storing the fire date in a property.
                    thisTimer.triggerDate = trigger.nextTriggerDate()
                    dump(thisTimer.triggerDate)
                    center.add(request) { (error) in
                        if let error = error {
                            NSLog("Could not convert timer to notification: \(error)")
                            return
                        }
                    }
                }
            }
        }
    }
    
    // When becoming active, we might have notifications
    // from an active timer that was converted to a notification
    // and that has not completed, so we need to remove the
    // notification and refresh the timer. Or if the notifications
    // completed, then we might have timers to reset.
    func convertNotificationsToTimers() {
        // first take care of those that have not completed to resume the timers
        // at the proper time
        center.getPendingNotificationRequests { requests in
            for request in requests {
                for (id, thisTimer) in self.timers.timers {
                    if request.identifier == String(id) {
                        if let timerTrigger = thisTimer.triggerDate {
                            let timeRemaining = timerTrigger.timeIntervalSinceNow
                            thisTimer.secondsLeft = Int(timeRemaining)
                            dump(thisTimer.triggerDate)
                        } else {
                            print("Error: triggerDate not set for timer: \(thisTimer)")
                            thisTimer.secondsLeft = 0
                        }
                        thisTimer.triggerDate = nil
                        self.center.removePendingNotificationRequests(withIdentifiers: [request.identifier])
                    }
                }
            }
        }
        // next clean up those that did complete, and remove the corresponding timers
        center.getDeliveredNotifications { (delivered) in
            for notification in delivered {
                for (id, thisTimer) in self.timers.timers {
                    if notification.request.identifier == String(id) {
                        thisTimer.secondsLeft = 0
                        thisTimer.shouldRing = false
                        self.center.removeDeliveredNotifications(withIdentifiers: [notification.request.identifier])
                    }
                }
            }
        }
        
    }
    
}

