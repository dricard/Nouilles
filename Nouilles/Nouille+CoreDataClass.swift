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
   
   var calories: Double?
   var fat: Double?
   var saturatedFat: Double?
   var transFat: Double?
   var sodium: Double?
   var carbs: Double?
   var fibre: Double?
   var sugars: Double?
   var protein: Double?
   var serving: Double?
}

public class Nouille: NSManagedObject {

   // MARK: - Properties
   
   let dataLabels = [
      "Name",
      "Brand",
      "Cooking time (mn)",
      "Meal serving size (cups)",
      "Side dish serving size (cups)",
      "Rating (0-5)",
      "Usually prefer meal size",
      "Have noodles on hand",
      "Nutritional info serving size",
      "Calories",
      "Fat (total, g)",
      "Saturated (g)",
      "Trans fats (g)",
      "Sodium (mg)",
      "Carbohydrate (g)",
      "Fibre (g)",
      "Sugars (g)",
      "Protein (g)",
   ]

   let cellTypes = [
      "TextCell",
      "TextCell",
      "NumberCell",
      "NumberCell",
      "NumberCell",
      "NumberCell",
      "BoolCell",
      "BoolCell",
      "NumberCell",
      "NumberCell",
      "NumberCell",
      "NumberCell",
      "NumberCell",
      "NumberCell",
      "NumberCell",
      "NumberCell",
      "NumberCell",
      "NumberCell",
      ]

   // MARK: - Tableview Datasource convinience methods
   
   func numberOfSection() -> Int {
      return 1
   }
   
   func numberOfRows(section: Int) -> Int {
      return dataLabels.count
   }
   
   func reuseIdentifier(indexPath: IndexPath) -> String {
      return cellTypes[indexPath.row]
   }
   
   func dataLabel(indexPath: IndexPath) -> String {
      return dataLabels[indexPath.row]
   }
   
   func data(indexPath: IndexPath) -> String {
      
      switch indexPath.row {
      case 0:
         return "\(name!)"
      case 1:
         return "\(brand!)"
      case 2:
         return "\(time!)"
      case 3:
         return "\(servingCustom!)"
      case 4:
         return "\(servingSideDish!)"
      case 5:
         return "\(rating!)"
      case 6:
         return "Prefer Meal Size"
      case 7:
         return "Have noodles on hand"
      case 8:
         return "\(serving!)"
      case 9:
         return "\(calories!)"
      case 10:
         return "\(fat!)"
      case 11:
         return "\(saturated!)"
      case 12:
         return "\(trans!)"
      case 13:
         return "\(sodium!)"
      case 14:
         return "\(carbs!)"
      case 15:
         return "\(fibre!)"
      case 16:
         return "\(sugar!)"
      case 17:
         return "\(protein!)"
      default:
         return ""
      }
      
   }
   
   func state(indexPath: IndexPath) -> Bool {
      
      if indexPath.row == 6 {
         return mealSizePrefered! as Bool
      } else if indexPath.row == 7 {
         return onHand! as Bool
      } else {
         // should not happen
         print("Bad parameter called")
         return true
      }
   }
   
   
   // MARK: - Network calling methods
   
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
            nouille.serving = result.serving as NSNumber?
            
            do {
               try context.save()
            } catch let error as NSError {
               print("Could not save context in checkForNutritionalInformation \(error), \(error.userInfo)")
            }

         }
      })

      
   }
   
   
}
