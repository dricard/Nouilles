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

   // NUTRITION API
   static let NutritionAPIBaseURL = "https://nutritionix-api.p.mashape.com/v1_1/"
   static let FindByStringPath = "search/"
   static let Fields = "fields"
   static let FieldsParameters = "item_name,item_id,brand_name,nf_calories,nf_total_fat"

   // Network request error codes (application specific)
   static let CodeFindByUPCRequestFailed = 101
   static let CodeSendRequestFailed = 102
   static let CodeNoDataReturned = 103
   static let CodeCouldNotParseData = 104
   static let CodeFindByStringRequestFailed = 105

}
