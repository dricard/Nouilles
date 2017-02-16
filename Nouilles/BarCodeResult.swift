//
//  BarCodeResult.swift
//  Nouilles
//
//  Created by Denis Ricard on 2017-01-23.
//  Copyright © 2017 Hexaedre. All rights reserved.
//

import UIKit

// This holds the potential results from the UPC barcode scanning

class BarCodeResult {

    // MARK: - properties
    var success = false
    var name: String?
    var brand: String?
    var servingSize: Double?
    var cookingTime: Double?
    var glutenFree: Bool?
    
}
