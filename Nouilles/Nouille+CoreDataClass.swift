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

enum DataCellTypes: String {
    case textCell = "TextCell"
    case valueCell = "NumberCell"
    case boolCell = "BoolCell"
}

public class Nouille: NSManagedObject {
    
    // MARK: - Properties
    
    let dataLabels: [String] = [
        .name,
        .brand,
        .cookingTime,
        .mealServingSize,
        .sideDishServingSize,
        .Rating,
        .preferMealSizeTitle,
        .onHandTitle,
        .referenceServingSize,
        .calories,
        .fat,
        .saturated,
        .trans,
        .sodium,
        .carbs,
        .fibre,
        .sugars,
        .protein,
        ]
    
    let unitsLabels = [
        "",
        "",
        .mn,
        .cups,
        .cups,
        "0-5 ⭐️",
        "",
        "",
        .cups,
        "",
        .g,
        .g,
        .g,
        .mg,
        .g,
        .g,
        .g,
        .g,
        ]
    
    let cellTypes: [DataCellTypes] = [
        .textCell,
        .textCell,
        .valueCell,
        .valueCell,
        .valueCell,
        .valueCell,
        .boolCell,
        .boolCell,
        .valueCell,
        .valueCell,
        .valueCell,
        .valueCell,
        .valueCell,
        .valueCell,
        .valueCell,
        .valueCell,
        .valueCell,
        .valueCell,
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
        return cellTypes[indexPath.row].rawValue
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
            return .preferMealSize
        case 7:
            return .onHand
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
    
    func updateText(newText: String, forDataAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            name = newText
        case 1:
            brand = newText
        default:
            break
        }
        
        do {
            try managedObjectContext?.save()
        } catch let error as NSError {
            print("Could not save context \(error), \(error.userInfo)")
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
    
    static func checkForNutritionalInformation(nouille: Nouille?, context: NSManagedObjectContext, completionHandlerForCaller: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
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
        
        NetworkCoordinator.findNutritionInformation(searchString: searchString, completionHandlerForFindNutritionInfoRequest: {(foodInfo, success, error) in
            
            // check for error
            guard error == nil else {
                // no need to print error, it was taken care in network code
                completionHandlerForCaller(false, error)
                return
            }
            
            // check for success
            guard success else {
                completionHandlerForCaller(false, error)
                return
            }
            
            if let result = foodInfo {
                // we have data
                
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
                completionHandlerForCaller(true, nil)
            } else {
                completionHandlerForCaller(false, error)
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
            returnedString += "\u{2151}"    // 1/9
        case 0.11806...0.13392:
            returnedString += "\u{215B}"  // 1/8
        case 0.13393...0.15475:
            returnedString += "\u{2150}" // 1/7
        case 0.15476...0.18332:
            returnedString += "\u{2159}" // 1/6
        case 0.18333...0.22499:
            returnedString += "\u{2155}" // 1/5
        case 0.22500...0.29166:
            returnedString += "\u{00BC}" // 1/4
        case 0.29168...0.35416:
            returnedString += "\u{2153}"  // 1/3
        case 0.35417...0.38749:
            returnedString += "\u{215C}"  // 3/8
        case 0.38750...0.44999:
            returnedString += "\u{2156}"  // 2/5
        case 0.45000...0.54999:
            returnedString += "\u{00BD}"  // 1/2
        case 0.55000...0.61249:
            returnedString += "\u{2157}"  // 3/5
        case 0.61250...0.64582:
            returnedString += "\u{215D}"  // 5/8
        case 0.64583...0.70832:
            returnedString += "\u{2154}"  // 2/3
        case 0.70833...0.77499:
            returnedString += "\u{00BE}"  // 3/4
        case 0.77500...0.81666:
            returnedString += "\u{2158}"  // 4/5
        case 0.81667...0.85416:
            returnedString += "\u{215A}"  // 5/6
        case 0.85417...0.93749:
            returnedString += "\u{215E}"  // 7/8
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
    
    static func formatedNutritionalInfo(for nutritionalInfo: String, with scaledValue: Double) -> String {
        
        switch nutritionalInfo {
        case "calories":
            // total calories in kcal. Always returned with precision of 0 decimal places
            let cal = Int(round(scaledValue))
            return "\(cal)"
        case "fat":
            // total fat in grams. Always returned with a precision of 1 decimal places
            let fats = round(scaledValue * 10) / 10
            return "\(fats) " + .g
        case "saturated":
            // saturated fat in grams. Always returned with a precision of 1 decimal places
            let saturateds = round(scaledValue * 10) / 10
            return "\(saturateds) " + .g
        case "trans":
            // trans fat in grams. Always returned with a precision of 1 decimal places
            let transString = round(scaledValue * 10) / 10
            return "\(transString) " + .g
        case "sodium":
            // sodium in milligrams. Always returned with a precision of 0 decimal places
            let sodiums = Int(round(scaledValue))
            return "\(sodiums) " + .mg
        case "carbs":
            // carbohydrate in grams. always returned with a precision of 0 decimal places
            let carbsString = Int(round(scaledValue))
            return "\(carbsString) " + .g
        case "fibre":
            // dietary fiber in grams. always returned with a precision of 0 decimal places
            let fibres = Int(round(scaledValue))
            return "\(fibres) " + .g
        case "sugar":
            // sugar in grams. Always returned with a precision of 0 decimal places
            let sugars = Int(round(scaledValue))
            return "\(sugars) " + .g
        case "protein":
            // protein in grams. Always returned with a precision of 0 decimal places
            let proteins = Int(round(scaledValue))
            return "\(proteins) " + .g
        default:
            print("Error, wrong parameter passed to formatedNutritionalInfo")
            return ""
        }
        
    }
    
    
}
