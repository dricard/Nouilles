//
//  FoodAPI.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-11-24.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import Foundation

class FoodAPI {
   
   static func sendFindUPCRequest(upc: String, completionHandlerForUPCRequest: @escaping (_ productInfo: [String:AnyObject]?, _ success: Bool, _ error: NSError?) -> Void) {

      let sessionConfig = URLSessionConfiguration.default
      
      /* Create session, and optionally set a URLSessionDelegate. */
      let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
      
      /* Example URL for GET request
      https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/food/products/upc/698997809166
      */
      
      // Build the URL
      guard let URL = URL(string: "\(NetworkParams.FoodAPIBaseURL)\(NetworkParams.FindByUPCPath)\(upc)") else {return}
      
      // Configure the request
      var request = URLRequest(url: URL)
      request.httpMethod = "GET"
      
      // Configure the Headers
      request.addValue(NetworkKeys.MashapeKey, forHTTPHeaderField: "X-Mashape-Key")
      request.addValue("application/json", forHTTPHeaderField: "Accept")
      
      // Make the request
      let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
         
         // Utility function
         func sendError(_ error: String, code: Int) {
            print("Error: \(error), code: \(code)")
            // build informative NSError to return
            let userInfo = [NSLocalizedDescriptionKey: error]
            completionHandlerForUPCRequest(nil, false, NSError(domain: "sendFindUPCRequest", code: code, userInfo: userInfo))
         }
         
         // GUARD: Was there an error returned by the URL request?
         guard error == nil else {
            sendError("SendFindByUPCRequest retuurned and error: \(error)", code: NetworkParams.CodeFindByUPCRequestFailed)
            return
         }
         
         // GUARD: did we get a successful 2XX response?
         guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            let theStatusCode = (response as? HTTPURLResponse)?.statusCode
            sendError("Network returned a status code outside the success range: \(theStatusCode)", code: NetworkParams.CodeSendRequestFailed)
            return
         }
         
         // GUARD: was there data returned?
         guard let data = data else {
            sendError("No data returned by the request!", code: NetworkParams.CodeNoDataReturned)
            return
         }
         
         // Parse the data
         let parsedResult = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
         
         // GUARD: make sure we could parse the data
         guard let productInfo = parsedResult else {
            sendError("Could not parse the data", code: NetworkParams.CodeCouldNotParseData)
            return
         }
         
         completionHandlerForUPCRequest(productInfo, true, nil)

      })
      task.resume()
      session.finishTasksAndInvalidate()
   }
}



