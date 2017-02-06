//
//  LocalizationUtilities.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-11-21.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import Foundation

// Convinience method to NSLocalizedString without a comment
fileprivate func NSLocalizedString(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}

/*  This is an extention of String which permits the use of
    a shorthand (like .save) anywhere a String is required
    which will return the localized string
*/

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
    
    static let field = NSLocalizedString("Field")
    
    static let name = NSLocalizedString("Name")
    static let brand = NSLocalizedString("Brand")
    static let mealServing = NSLocalizedString("Meal serving")
    static let sdMealServing = NSLocalizedString("Side-dish serving")
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
    static let networkError = NSLocalizedString("Network Error")
    static let codeSendRequestFailed = NSLocalizedString("The server did not respond to the request for nutritional information.")
    static let codeNoDataReturned = NSLocalizedString("Could not get nutritional information from the server.")
    static let codeCouldNotParseData = NSLocalizedString("Could not get nutritional information from the server.")
    static let codeFindByStringRequestFailed = NSLocalizedString("There was an error with the network request. Check your network connection.")
    static let codeByDefault = NSLocalizedString("There was an error with the network request.")
    
    // MARK: - Edit noodle
    
    static let mealServingSize = NSLocalizedString("Meal serving size")
    static let sideDishServingSize = NSLocalizedString("Side-dish serving size")
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
    static let editTitle = NSLocalizedString("Edit")
    
    // MARK: - Units
    static let mn = NSLocalizedString("min")
    static let cups = NSLocalizedString("cups")
    static let cp = NSLocalizedString("cp")
    static let g = NSLocalizedString("g")
    static let mg = NSLocalizedString("mg")

    // MARK: - About
    static let aboutNoodles = NSLocalizedString("About Noodles")
    static let noodles = NSLocalizedString("Noodles")
    static let isMadeByLabel = NSLocalizedString("is made by")
    static let dedicatedToLabel = NSLocalizedString("Noodles is dedicated to")
    static let dedicationLabel = NSLocalizedString("Dominique, Coralie and Florence — for their patience and their love of noodles!")
    static let ringCredits = NSLocalizedString("Ring sound provided by Mike Koenig on http://soundbible.com")
    static let helpButtonLabel = NSLocalizedString("Help")
    static let supportButtonLabel = NSLocalizedString("Support")

    // MARK: - Filters
    
    static let filtersLabel = NSLocalizedString("Filters")
    static let byName = NSLocalizedString("By Name")
    static let byBrand = NSLocalizedString("By Brand")
    static let byRating = NSLocalizedString("By Rating")
    static let byCookingTime = NSLocalizedString("By Cooking Time")
    static let all = NSLocalizedString("All")
    static let sortByName = NSLocalizedString("Sort by name")
    static let sortByBrand = NSLocalizedString("Sort by Brand, then by name")
    static let sortByRating = NSLocalizedString("Sort by Rating, then by name")
    static let sortByTime = NSLocalizedString("Sort by cooking time, then by name")
    static let onHandTitleAvailable = NSLocalizedString("Available")
    static let onHandTitleUnavailable = NSLocalizedString("Unavailable")
    static let allNoodles = NSLocalizedString("All noodles")
    static let onHandNoodles = NSLocalizedString("Only those listed as available")
    static let notOnHandNoodles = NSLocalizedString("Only those listed as unavailable")
    static let sortTitle = NSLocalizedString("Sort")
    static let predicateTitle = NSLocalizedString("Show")
    static let aboutButtonLabel = NSLocalizedString("About")
    
    // MARK: - Bar Code scanning
    
    static let successful = NSLocalizedString("Success")
    static let failure = NSLocalizedString("Failed")
    static let successWithData = NSLocalizedString("Data was returned from the server")
    static let failureToReturnData = NSLocalizedString("No data was provided by the server")
    static let failureToCommunicateWithAPI = NSLocalizedString("Unable to communicate successfully with the server")
    
    // MARK: - Take Picture VC
    
    static let noCameraOnDevice = NSLocalizedString("Choose an image from the Album \n(no camera on this device)")
    static let cameraAvailableOnDevice = NSLocalizedString("Choose from the album\nor take a picture")
    
    // MARK: - Change Value
    
    static let currentValueLabel = NSLocalizedString("Current value")
    static let enterValueLabel = NSLocalizedString("Enter a new value for")
}
