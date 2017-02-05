//
//  scanSuccessView.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-11-25.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit

/// ScanSuccessView is used to display the scanning success by overriding
/// the draw method with a call to a PainCode generated draw method
/// for the appropriate state
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
