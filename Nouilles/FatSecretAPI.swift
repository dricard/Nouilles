//
//  FatSecretAPI.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-12-05.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import Foundation

class FatSecretAPI {
   
    /// This send a request to FatSecret's API with a search string to find the Noodle's nutritional
    /// information.
    static func findNutritionInformation(searchString: String, completionHandlerForFindNutritionInfoRequest: @escaping (_ foodInfo: NutritionInfoData?, _ success: Bool, _ error: NSError?) -> Void) {
      
      // Get the parameters common to all requests
      var normalizedParams = FatSecretAPI.commonParameters()
      
      // set specific parameters for this call: foods.search
      let httpMethod = "GET"
      let requestURL = NetworkParams.FatSecretAPIBaseURL
      let requestParams: [(String, String)] = [ ("method", "foods.search"), ("format", "json"), ("search_expression", searchString)]

      // add specific parameters to common parameters
      for parameters in requestParams {
         normalizedParams.append(parameters)
      }

      // get the signature
      let signature = FatSecretAPI.signOauthRequest(httpMethod: httpMethod, requestURL: requestURL, requestParams: normalizedParams)
      
      // and add this to the parameters
      normalizedParams.append(("oauth_signature", signature))

      // now send the request

      let sessionConfig = URLSessionConfiguration.default
      
      // Create the session
      let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
      
      // Build the URL for GET request
      guard var URL = URL(string: NetworkParams.FatSecretAPIBaseURL) else {return}
      
      // Build parameters dictionary
      var URLParams: [String:String] = [:]
      
      for (field, value) in normalizedParams {
         URLParams[field] = value
      }
      
      // add the parameters to the URL
      URL = URL.appendingQueryParameters(URLParams)

      // create the request
      var request = URLRequest(url: URL)
      request.httpMethod = httpMethod

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
         guard let _ = parsedResult??["hits"] as? [[String:AnyObject]] else {
            sendError("Could not parse the data", code: NetworkParams.CodeCouldNotParseData)
            return
         }
         
//         // extract useful information from parsed data
//         
//         let infoArray: [String:AnyObject] = result.first!["fields"] as! [String : AnyObject]
//         
//         let calories = infoArray["nf_calories"] as? Double
//         let fat = infoArray["nf_total_fat"] as? Double
//         let saturatedFat = infoArray["nf_saturated_fat"] as? Double
//         let transFat = infoArray["nf_trans_fatty_acid"] as? Double
//         let sodium = infoArray["nf_sodium"] as? Double
//         let carbs = infoArray["nf_total_carbohydrate"] as? Double
//         let fibre = infoArray["nf_dietary_fiber"] as? Double
//         let sugars = infoArray["nf_sugars"] as? Double
//         let protein = infoArray["nf_protein"] as? Double
//         let serving = infoArray["nf_serving_size_qty"] as? Double
//         
//         // return the information to calling method
//         
         let foodInfo = NutritionInfoData(calories: 200, fat: 3, saturatedFat: 0.3, transFat: 0, sodium: 5, carbs: 61, fibre: 3, sugars: 6, protein: 11, serving: 1)
         
         completionHandlerForFindNutritionInfoRequest(foodInfo, true, nil)
         
         
      })
      task.resume()
      session.finishTasksAndInvalidate()
   }
   
   static func commonParameters() -> [(String, String)] {

      // 0. Create common parameters variables
      
      let timeStamp = Int64(NSDate().timeIntervalSince1970)
    
      let nonce = UUID().uuidString
    
      let commonParams = [
         ("oauth_consumer_key", NetworkKeys.FSConsumerKey),
         ("oauth_signature_method", "HMAC-SHA1"),
         ("oauth_timestamp", "\(timeStamp)"),
         ("oauth_nonce", nonce),
         ("oauth_version", "1.0")
      ]
      return commonParams
   }
   
   static func signOauthRequest(httpMethod: String, requestURL: String, requestParams: [(String, String)]) -> String {
      
      // 1. create a signature base string
      
      // concatenate the parameters after sorting them
      let normalizedParametersString = FatSecretAPI.createNormalizedStringFrom(normalizedParameters: requestParams)
      
      // percent encode all 3 parts
      let httpMethodEncoded = httpMethod.addingPercentEncoding(withAllowedCharacters: CharacterSet.URLQueryParametersAllowedCharacterSet())!
      let requestURLEncoded = requestURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.URLQueryParametersAllowedCharacterSet())!
      let normalizedParametersStringEncoded = normalizedParametersString.addingPercentEncoding(withAllowedCharacters: CharacterSet.URLQueryParametersAllowedCharacterSet())!
      
      // create the signature base string from all 3 parts
      let signatureBaseString = "\(httpMethodEncoded)&\(requestURLEncoded)&\(normalizedParametersStringEncoded)"

      // Encode signature string using HMAC-SAH1
      let signature = FatSecretAPI.signRequest(signatureBaseString)

      return signature
   }
   
   // This creates the normalize string by building key=value pairs, then
   // sorting them using lexicographical byte value ordering
   static func createNormalizedStringFrom(normalizedParameters: [(String, String)]) -> String {
      
      var parts: [String] = []
      
      for (key, value) in normalizedParameters {
         let part = String(format: "%@=%@", String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
         parts.append(part)
      }
      parts.sort()
      
      return parts.joined(separator: "&")
      
   }

   // this does the required signing process
   static func signRequest(_ signatureBaseString: String) -> String {
      
      // this is limited in scope since I won't be using methods that require
      // access tokens for this app. this would need to me modified in case
      // where there is an access token
      
      let key = "\(NetworkKeys.FSConsumerKey)&"
      
      let hashed = FatSecretAPI.hmac(key: key, data: signatureBaseString)
      
      // here we have to base64-encode this, then escape it with percent-encoding (RFC3986)
      // and returned the digest octet string
      let data = hashed.data(using: String.Encoding.utf8)
      let base64 = data!.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)).characters
      let base64_28 = String(base64.dropLast(base64.count - 28))
      let escaped = base64_28.addingPercentEncoding(withAllowedCharacters: CharacterSet.URLQueryParametersAllowedCharacterSet())!
      
      return escaped
   }
   
   // this is a utility function to do the HMAC-SHA1 part
   // this was adapted/translated from an answer on stack overflow
   static func hmac(key: String, data: String) -> String {
      
      // This was tested [here](http://www.freeformatter.com/hmac-generator.html)
      // and passed the test (same result as my algorithm for the same data/key)
      var result: [CUnsignedChar]
      if let cKey = key.cString(using: String.Encoding.utf8), let cData = data.cString(using: String.Encoding.utf8) {
         let crypto = CCHmacAlgorithm(kCCHmacAlgSHA1)
         result = Array(repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
         
         CCHmac(crypto, cKey, cKey.count-1, cData, cData.count-1, &result)
         
      } else {
         fatalError("Nil returned when processing input strings as UTF8")
      }
      
      let hash = NSMutableString()
      for val in result {
         hash.appendFormat("%02hhx", val)
      }
      
      return hash as String
      
   }

}
