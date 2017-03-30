//
//  NutritionAPI.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-11-27.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import Foundation

class NutritionAPI {
    
    /// This send a request to Nutritionix's API with a search string to find the Noodle's nutritional
    /// information.
    static func findNutritionInformation(searchString: String, completionHandlerForFindNutritionInfoRequest: @escaping (_ foodInfo: NutritionInfoData?, _ success: Bool, _ error: NSError?) -> Void) {
        
        let sessionConfig = URLSessionConfiguration.default
        
        // Create session
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        // Build the URL for GET request
        guard var URL = URL(string: "\(NetworkParams.NutritionAPIBaseURL)\(NetworkParams.FindByStringPath)") else {return}
        
        URL = URL.appendingPathComponent("\(searchString)")
        
        // Build URL parameters
        let URLParams = [
            NetworkParams.Fields: NetworkParams.FieldsParameters,
            ]
        
        URL = URL.appendingQueryParameters(URLParams)
        
        // Create request
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
                completionHandlerForFindNutritionInfoRequest(nil, false, NSError(domain: "findNutritionInformation", code: code, userInfo: userInfo))
            }
            
            // GUARD: Was there an error returned by the URL request?
            guard error == nil else {
                sendError("findNutritionInformation returned and error: \(String(describing: error))", code: NetworkParams.CodeFindByStringRequestFailed)
                return
            }
            
            // GUARD: did we get a successful 2XX response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                let theStatusCode = (response as? HTTPURLResponse)?.statusCode
                sendError("Network returned a status code outside the success range: \(String(describing: theStatusCode))", code: NetworkParams.CodeSendRequestFailed)
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
            guard let result = parsedResult??["hits"] as? [[String:AnyObject]] else {
                sendError("Could not parse the data", code: NetworkParams.CodeCouldNotParseData)
                return
            }
            
            // extract useful information from parsed data
            
            let infoArray: [String:AnyObject] = result.first!["fields"] as! [String : AnyObject]
            
            let calories = infoArray["nf_calories"] as? Double
            let fat = infoArray["nf_total_fat"] as? Double
            let saturatedFat = infoArray["nf_saturated_fat"] as? Double
            let transFat = infoArray["nf_trans_fatty_acid"] as? Double
            let sodium = infoArray["nf_sodium"] as? Double
            let carbs = infoArray["nf_total_carbohydrate"] as? Double
            let fibre = infoArray["nf_dietary_fiber"] as? Double
            let sugars = infoArray["nf_sugars"] as? Double
            let protein = infoArray["nf_protein"] as? Double
            let serving = infoArray["nf_serving_size_qty"] as? Double
            
            // return the information to calling method
            
            let foodInfo = NutritionInfoData(calories: calories, fat: fat, saturatedFat: saturatedFat, transFat: transFat, sodium: sodium, carbs: carbs, fibre: fibre, sugars: sugars, protein: protein, serving: serving)
            
            completionHandlerForFindNutritionInfoRequest(foodInfo, true, nil)
            
            
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
}




