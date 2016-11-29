//
//  Nouille+CoreDataClass.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-11-15.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import Foundation
import CoreData

struct NutritionInfoData {
   
   var calories: Int?
   var fat: Double?
   var saturatedFat: Double?
   var transFat: Double?
   var sodium: Double?
   var carbs: Double?
   var fibre: Double?
   var sugars: Double?
   var protein: Double?
   
}

public class Nouille: NSManagedObject {

   // MARK: - Properties
   
   static func checkForNutritionalInformation(nouille: Nouille?, context: NSManagedObjectContext) {
 
      /// This checks if we already have nutritional informations
      /// - returns: false if if we already have nutritional information, and true 
      ///   if we should fetch the data from the network
      func shouldFetchNutritionalInformation(_ nouille: Nouille) -> Bool {
         // TODO: -  Find a better way to test if we already have nutritional information
         if nouille.calories == nil || nouille.calories == 0 {
            return true
         } else {
            return false
         }
      }

      // first make sure there is a non-nil nouille passed in
      guard let nouille = nouille else { return }
      
      // then check if the information is already available
      guard shouldFetchNutritionalInformation(nouille) else { return }
      
      // we need data, so request it from the NetworkCoordinator
      let searchString = "\(nouille.name!) \(nouille.brand!) noodles"
      print("Sending request to network with search string: \(searchString)")
      NetworkCoordinator.findNutritionInformation(searchString: searchString, completionHandlerForFindNutritionInfoRequest: {(foodInfo, success, error) in
         
         // check for error
         guard error == nil else {
            // no need to print error, it was taken care in network code
            return
         }
         
         // check for success
         guard success else {
            return
         }
         
         if let result = foodInfo {
            // we have data
            print("IN MODEL WITH DATA")
            print(result)
            
            nouille.calories = result.calories as NSNumber?
            nouille.fat = result.fat as NSNumber?
            nouille.saturated = result.saturatedFat as NSNumber?
            nouille.trans = result.transFat as NSNumber?
            nouille.sodium = result.sodium as NSNumber?
            nouille.carbs = result.carbs as NSNumber?
            nouille.fibre = result.fibre as NSNumber?
            nouille.sugar = result.sugars as NSNumber?
            nouille.protein = result.protein as NSNumber?
            
            do {
               try context.save()
            } catch let error as NSError {
               print("Could not save context in checkForNutritionalInformation \(error), \(error.userInfo)")
            }

         }
      })

      
   }
   
   
}
