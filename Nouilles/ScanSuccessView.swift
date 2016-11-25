//
//  scanSuccessView.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-11-25.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit

class ScanSuccessView: UIView {
   
   // MARK: - Properties
   
   private var state: Bool = false
   
   var successState: Bool {
      set (newState) {
         state = newState
         setNeedsDisplay()
      }
      get {
         return state
      }
   }
   override func draw(_ rect: CGRect) {
      
      if state {
         NoodlesStyleKit.drawScanSuccess()
      } else {
         NoodlesStyleKit.drawScanFailure()
      }
   }
   
}
