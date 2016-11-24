//
//  NetworkParameters.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-11-24.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import Foundation

// Here I use an enum instead of a struct because case-less enum
// cannot be instantiated. This way prevents unintentional 
// instantiation
enum NetworkParams {
   
   // FOOD API
   static let FoodAPIBaseURL = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/food/"
   static let FindByUPCPath = "products/upc/"
   
   // Network request error codes
   static let CodeFindByUPCRequestFailed = 101
   static let CodeSendRequestFailed = 102
   static let CodeNoDataReturned = 103
   static let CodeCouldNotParseData = 104

}
