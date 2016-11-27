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
   
   enum scanningStates {
      case processing
      case failure
      case success
   }
   
   private var state: scanningStates = .processing
   
   var successState: scanningStates {
      set (newState) {
         state = newState
         setNeedsDisplay()
      }
      get {
         return state
      }
   }
   override func draw(_ rect: CGRect) {
      
      switch state {
      case .processing:
         NoodlesStyleKit.drawScanProcessing()
      case .failure:
         NoodlesStyleKit.drawScanFailure()
      case .success:
         NoodlesStyleKit.drawScanSuccess()

      }
   }
   
}
