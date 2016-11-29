//
//  NetworkCoordinator.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-11-29.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import Foundation

/* This class is responsible to coordinate between the
   various APIs. It is meant to be a bridge between both the
   VC and Model and the Network. This way it is possible to
   change APIs endpoints without having to change the VC
   or Model code. We just need to modify this file to point
   to a different API, and a different JSON parser for
   instance.
 
   The VC should ask the Model for data to display. It never
   should have to interface with the Network directly, only
   through the Model.
 
   The Model should provide the data to the VC. If the
   Model doesn't have the data, it should request it from
   the NetworkCoordinator.
 
   The NetworkCoordinator is responsible to fetch data from
   the network through the most appropriate API and to extract
   or parse the useful data from the response.
   It might send a barcode scanning request to one API and
   a nutrition info request to another for instance, and know
   how to parse each response.
 
 */

class NetworkCoordinator {
   
   // MARK: - Interface
   
   static func sendFindUPCRequest(upc: String, completionHandlerForUPCRequest: @escaping (_ productInfo: [String:AnyObject]?, _ success: Bool, _ error: NSError?) -> Void) {
      
   }
   
   static func findNutritionInformation(searchString: String, completionHandlerForFindNutritionInfoRequest: @escaping (_ foodInfo: NutritionInfoData?, _ success: Bool, _ error: NSError?) -> Void)  {
      
      NutritionAPI.findNutritionInformation(searchString: searchString, completionHandlerForFindNutritionInfoRequest: completionHandlerForFindNutritionInfoRequest)

   }
}
