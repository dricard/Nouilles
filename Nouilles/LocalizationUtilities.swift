//
//  LocalizationUtilities.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-11-21.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import Foundation

fileprivate func NSLocalizedString(_ key: String) -> String {
   return NSLocalizedString(key, comment: "")
}

extension String {
   
   // Add Noodle VC
   
   static let save = NSLocalizedString("Save")
   static let cancel = NSLocalizedString("Cancel")
   static let Back = NSLocalizedString("Back")
   static let time = NSLocalizedString("Time")
   static let serving = NSLocalizedString("serving")
   static let meal = NSLocalizedString("meal")
   static let sideDish = NSLocalizedString("side dish")
   static let rating = NSLocalizedString("rating")

   static let field = NSLocalizedString("field")

   static let name = NSLocalizedString("Name")
   static let brand = NSLocalizedString("Brand")
   static let mealServing = NSLocalizedString("Meal serving")
   static let sdMealServing = NSLocalizedString("Side dish serving")
   static let cookingTime = NSLocalizedString("Cooking time")
   static let ratingCap = NSLocalizedString("Rating")

   static let unsavedEntry = NSLocalizedString("Unsaved entry")
   static let areYouSure = NSLocalizedString("You have entered some data and have not saved, are you sure you want to discard the data?")
   static let discard = NSLocalizedString("Discard")
   static let invalidEntry = NSLocalizedString("Invalid Entry")
   static let ok = NSLocalizedString("ok")

   // Data validation
   
   static let empty = NSLocalizedString("cannot be empty")
   static let notANumber = NSLocalizedString("must be a number")
   static let negativeOrZero = NSLocalizedString("cannot be negative")
   static let tooBig = NSLocalizedString("is outside the allowed range of values")
   static let invalid = NSLocalizedString("is invalid")
   
   // NouilleDetailVC
   
   static let noData = NSLocalizedString("no data")
}
