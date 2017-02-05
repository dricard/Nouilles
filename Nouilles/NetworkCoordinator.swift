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
    
    // MARK: - Definitions
    
    enum foodAPIProviders {
        case nutritionix
        case fatSecret
    }
    
    // MARK: - Interface
    
    /// This sends a request to Spoonacular with the barcode's UPC to try and find some information
    /// about the noodle scanned to reduce the need for typing for the user.
    static func sendFindUPCRequest(upc: String, completionHandlerForUPCRequest: @escaping (_ productInfo: [String:AnyObject]?, _ success: Bool, _ error: NSError?) -> Void) {
        
        let sessionConfig = URLSessionConfiguration.default
        
        // Create session
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
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
                sendError("SendFindByUPCRequest returned and error: \(error)", code: NetworkParams.CodeFindByUPCRequestFailed)
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
    
    /// This fetches nutritional information from a REST API. It is configured to fetch from one of
    /// two APIs, either FatSecret or Nutritionix. It could be configurable through a preference,
    /// but right now it is hard coded to fetch fro Nutritionix. The oauth protocol is not working
    /// at the moment.
    static func findNutritionInformation(searchString: String, completionHandlerForFindNutritionInfoRequest: @escaping (_ foodInfo: NutritionInfoData?, _ success: Bool, _ error: NSError?) -> Void)  {
        
        let selectedAPI: foodAPIProviders = .nutritionix
        
        switch selectedAPI {
        case .fatSecret:
            FatSecretAPI.findNutritionInformation(searchString: searchString, completionHandlerForFindNutritionInfoRequest: completionHandlerForFindNutritionInfoRequest)
        case .nutritionix:
            NutritionAPI.findNutritionInformation(searchString: searchString, completionHandlerForFindNutritionInfoRequest: completionHandlerForFindNutritionInfoRequest)
        }
        
    }
}

// These protocols and extensions are used by the various APIs. we define them
// here so they all can use them

protocol URLQueryParameterStringConvertible {
    var queryParameters: String { get }
}

extension Dictionary: URLQueryParameterStringConvertible {
    
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                              String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                              String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        parts.sort()
        return parts.joined(separator: "&")
    }
    
}

extension String {
    
    func appendingQueryParameters(_ parametersDictionary: Dictionary<String, String>) -> String {
        let URLString: String = String(format: "%@?%@", self, parametersDictionary.queryParameters)
        return URLString
    }
}

extension URL {
    
    func appendingQueryParameters(_ parametersDictionary: Dictionary<String, String>) -> URL {
        let URLString: String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString)!
    }
    
    func appendingSignatureParameter(_ signature: String) -> URL {
        let URLString: String = String(format: "%@&%@", self.absoluteString, "oauth_signature=\(signature)")
        return URL(string: URLString)!
        
    }
    
}

extension CharacterSet {
    
    static func URLQueryParametersAllowedCharacterSet() -> CharacterSet {
        return self.init(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-._~0123456789")
    }
    
}

