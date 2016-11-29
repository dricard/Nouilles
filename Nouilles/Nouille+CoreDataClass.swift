//
//  Nouille+CoreDataClass.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-11-15.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import Foundation
import CoreData

public class Nouille: NSManagedObject {

   // MARK: - Properties
   
   
   static func checkForNutritionalInformation(nouille: Nouille?) {
 
      func isNutritionInformationAvailable(_ nouille: Nouille) -> Bool {
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
      guard isNutritionInformationAvailable(nouille) else { return }
      
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
            
            // TODO: - we should save it to the context so it's available elsewhere
         }
      })

      
   }
   
   
}
