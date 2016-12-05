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
      "Cooking time",
      "Meal serving size",
      "Side dish serving size",
      "Rating",
      "Usually prefer meal size",
      "Have noodles on hand",
      "Nutritional info serving size",
      "Calories",
      "Fat",
      "Saturated",
      "Trans fats",
      "Sodium",
      "Carbohydrate",
      "Fibre",
      "Sugars",
      "Protein",
   ]

   let unitsLabels = [
      "",
      "",
      "mn",
      "cups",
      "cups",
      "0-5 ⭐️",
      "",
      "",
      "cups",
      "",
      "g",
      "g",
      "g",
      "mg",
      "g",
      "g",
      "g",
      "g",
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

   let validatorConfigurator = ValidatorConfigurator.sharedInstance

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
   
   func unitsLabel(indexPath: IndexPath) -> String {
      return unitsLabels[indexPath.row]
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
   
   func validator(indexPath: IndexPath) -> Validator {
      switch indexPath.row {
      case 0:
         return validatorConfigurator.nameValidator()
      case 1:
         return validatorConfigurator.brandValidator()
      case 2:
         return validatorConfigurator.cookingTimeValidator()
      case 3:
         return validatorConfigurator.numberValidator()
      case 4:
         return validatorConfigurator.numberValidator()
      case 5:
         return validatorConfigurator.ratingValidator()
      case 6:
         return validatorConfigurator.boolValidator()
      case 7:
         return validatorConfigurator.boolValidator()
      case 8:
         return validatorConfigurator.numberValidator()
      case 9:
         return validatorConfigurator.numberValidator()
      case 10:
         return validatorConfigurator.numberValidator()
      case 11:
         return validatorConfigurator.numberValidator()
      case 12:
         return validatorConfigurator.numberValidator()
      case 13:
         return validatorConfigurator.numberValidator()
      case 14:
         return validatorConfigurator.numberValidator()
      case 15:
         return validatorConfigurator.numberValidator()
      case 16:
         return validatorConfigurator.numberValidator()
      case 17:
         return validatorConfigurator.numberValidator()
      default:
         return validatorConfigurator.boolValidator()
      }
      
   }

   func updateValue(value: Double, forDataAt indexPath: IndexPath)  {
      
      switch indexPath.row {
      case 0:
         break
      case 1:
         break
      case 2:
         time = value as NSNumber?
      case 3:
         servingCustom = value as NSNumber?
      case 4:
         servingSideDish = value as NSNumber?
      case 5:
         rating = value as NSNumber?
      case 6:
         break
      case 7:
         break
      case 8:
         serving = value as NSNumber?
      case 9:
         calories = value as NSNumber?
      case 10:
         fat = value as NSNumber?
      case 11:
         saturated = value as NSNumber?
      case 12:
         trans = value as NSNumber?
      case 13:
         sodium = value as NSNumber?
      case 14:
         carbs = value as NSNumber?
      case 15:
         fibre = value as NSNumber?
      case 16:
         sugar = value as NSNumber?
      case 17:
         protein = value as NSNumber?
      default:
         break
      }
      
      do {
         try managedObjectContext?.save()
      } catch let error as NSError {
         print("Could not save context \(error), \(error.userInfo)")
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
   
   // MARK: - Convinience methods
   
   static func formatWithFraction(value: Double) -> String {
      
      var integerPart = Int(value)
      let fractionalPart = value.truncatingRemainder(dividingBy: 1.0)
      
      var returnedString = integerPart != 0 ? "\(integerPart)" : ""
      
      switch fractionalPart {
      case 0.00001...0.05555:
         // drop the fractional part
         break
      case 0.05556...0.11805:
         returnedString += "⅑"
      case 0.11806...0.13392:
         returnedString += "⅛"
      case 0.13393...0.15475:
         returnedString += "⅐"
      case 0.15476...0.18332:
         returnedString += "⅙"
      case 0.18333...0.22499:
         returnedString += "⅕"
      case 0.22500...0.29166:
         returnedString += "¼"
      case 0.29168...0.35416:
         returnedString += "⅓"
      case 0.35417...0.38749:
         returnedString += "⅜"
      case 0.38750...0.44999:
         returnedString += "⅖"
      case 0.45000...0.54999:
         returnedString += "½"
      case 0.55000...0.61249:
         returnedString += "⅗"
      case 0.61250...0.64582:
         returnedString += "⅝"
      case 0.64583...0.70832:
         returnedString += "⅔"
      case 0.70833...0.77499:
         returnedString += "¾"
      case 0.77500...0.81666:
         returnedString += "⅘"
      case 0.81667...0.85416:
         returnedString += "⅚"
      case 0.85417...0.93749:
         returnedString += "⅞"
      case 0.93750...0.99999:
         // round to next interger, drop remainder
         integerPart += 1
         returnedString = "\(integerPart)"
      default:
         if fractionalPart != 0 {
            let rounded = Int(fractionalPart * 100)
            returnedString += ".\(rounded)"
         }
      }
      
      return returnedString
   }
   
   static func formatWithExponent(value: Double) -> String {
      
      var integerPart = Int(value)
      let fractionalPart = value.truncatingRemainder(dividingBy: 1.0)
      
      var returnedString = integerPart != 0 ? "\(integerPart)" : "0"
      
      switch fractionalPart {
      case 0.00001...0.04166:
         // drop too small fraction
         break
      case 0.04167...0.12499:
         returnedString += "⁰⁵"
      case 0.12500...0.20832:
         returnedString += "¹⁰"
      case 0.20833...0.29166:
         returnedString += "¹⁵"
      case 0.29167...0.37499:
         returnedString += "²⁰"
      case 0.37500...0.45832:
         returnedString += "²⁵"
      case 0.45833...0.54166:
         returnedString += "³⁰"
      case 0.54167...0.62499:
         returnedString += "³⁵"
      case 0.62500...0.70832:
         returnedString += "⁴⁰"
      case 0.70833...0.79166:
         returnedString += "⁴⁵"
      case 0.79167...0.87499:
         returnedString += "⁵⁰"
      case 0.87500...0.95832:
         returnedString += "⁵⁵"
      case 0.95833...0.99999:
         // round to next interger, drop remainder
         integerPart += 1
         returnedString = "\(integerPart)"
      default:
         if fractionalPart != 0 {
            let rounded = Int(fractionalPart * 100)
            returnedString += ".\(rounded)"
         }
      }
      
      return returnedString
   }
   

   
}
