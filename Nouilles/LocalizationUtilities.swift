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
    
    // MARK: Add Noodle VC
    
    static let addNoodleTitle = NSLocalizedString("Add Noodle")
    static let editButtonlabel = NSLocalizedString("Edit")
    
    static let save = NSLocalizedString("Save")
    static let cancel = NSLocalizedString("Cancel")
    static let Back = NSLocalizedString("Back")
    static let time = NSLocalizedString("Time")
    static let serving = NSLocalizedString("serving")
    static let meal = NSLocalizedString("meal")
    static let sideDish = NSLocalizedString("side dish")
    static let rating = NSLocalizedString("rating")
    static let Rating = NSLocalizedString("Rating")
    
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
    
    // MARK: - List view
    
    static let toggle = NSLocalizedString("Toggle")
    static let onHandLabel = NSLocalizedString("On Hand")
    static let delete = NSLocalizedString("Delete")
    
    // MARK: Data validation
    
    static let empty = NSLocalizedString("cannot be empty")
    static let notANumber = NSLocalizedString("must be a number")
    static let negativeOrZero = NSLocalizedString("cannot be negative")
    static let tooBig = NSLocalizedString("is outside the allowed range of values")
    static let invalid = NSLocalizedString("is invalid")
    
    // MARK: NouilleDetailVC
    
    static let noData = NSLocalizedString("no data")
    static let timerStartLabel = NSLocalizedString("Start Timer")
    static let timerShowLabel = NSLocalizedString("Show Timer")
    static let numberOfPeopleLabel = NSLocalizedString("# of people")
    
    // MARK: - Edit noodle
    
    static let mealServingSize = NSLocalizedString("Meal serving size")
    static let sideDishServingSize = NSLocalizedString("Side dish serving size")
    static let preferMealSize = NSLocalizedString("Usually prefer meal size")
    static let onHand = NSLocalizedString("Have noodles on hand")
    static let preferMealSizeTitle = NSLocalizedString("Meal size preference")
    static let onHandTitle = NSLocalizedString("Noodle availability")
    static let referenceServingSize = NSLocalizedString("Nutritional info serving size")
    static let calories = NSLocalizedString("Calories")
    static let fat = NSLocalizedString("Fat")
    static let saturated = NSLocalizedString("Saturated")
    static let trans = NSLocalizedString("Trans fats")
    static let sodium = NSLocalizedString("Sodium")
    static let carbs = NSLocalizedString("Carbohydrate")
    static let fibre = NSLocalizedString("Fibre")
    static let sugars = NSLocalizedString("Sugars")
    static let protein = NSLocalizedString("Protein")
    
    // MARK: - Units
    static let mn = NSLocalizedString("mn")
    static let cups = NSLocalizedString("cups")
    static let cp = NSLocalizedString("cp")
    static let g = NSLocalizedString("g")
    static let mg = NSLocalizedString("mg")

}
