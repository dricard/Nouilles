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
   
   static let FoodAPIBaseURL = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/food/"
   static let FindByUPCPath = "products/upc/"
}
