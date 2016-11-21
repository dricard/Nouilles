//
//  LocalizationUtilities.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-11-21.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import Foundation

fileprivate func NSLocalizedString(_ key: String) -> String {
   return NSLocalizedString(key, comment: "")
}

extension String {
   static let save = NSLocalizedString("Save")
   static let cancel = NSLocalizedString("Cancel")
   static let Back = NSLocalizedString("Back")
   static let time = NSLocalizedString("Time")
   static let serving = NSLocalizedString("serving")
   static let meal = NSLocalizedString("meal")
   static let sideDish = NSLocalizedString("side dish")
   static let rating = NSLocalizedString("rating")
   
}
