//
//  FoodAPI.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-11-24.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import Foundation

class FoodAPI {
   
   static func sendFindUPCRequest(upc: String) {

      let sessionConfig = URLSessionConfiguration.default
      
      /* Create session, and optionally set a URLSessionDelegate. */
      let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
      
      /* Create the Request:
       Example UPC (GET https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/food/products/upc/698997809166)
       */
      
      guard let URL = URL(string: "\(NetworkParams.FoodAPIBaseURL)\(NetworkParams.FindByUPCPath)\(upc)") else {return}
      var request = URLRequest(url: URL)
      request.httpMethod = "GET"
      
      // Headers
      
      request.addValue(NetworkKeys.MashapeKey, forHTTPHeaderField: "X-Mashape-Key")
      request.addValue("application/json", forHTTPHeaderField: "Accept")
      
      /* Start a new Task */
      let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
         if (error == nil) {
            // Success
            let statusCode = (response as! HTTPURLResponse).statusCode
            print("URL Session Task Succeeded: HTTP \(statusCode)")
            print(data!)
         }
         else {
            // Failure
            print("URL Session Task Failed: %@", error!.localizedDescription);
         }
      })
      task.resume()
      session.finishTasksAndInvalidate()
   }
}



