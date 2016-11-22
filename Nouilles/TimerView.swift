//
//  TimerView.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-11-21.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit

class TimerView: UIView {
   
   // MARK: - Properties
   
   private var ratio: CGFloat = 0.0
   
   var progress: CGFloat {
      set (newProgress) {
         if newProgress > 1.0 {
            ratio = 1.0
         } else if newProgress < 0.0 {
            ratio = 0.0
         } else {
            ratio = newProgress
         }
         setNeedsDisplay()
      }
      get {
         return ratio
      }
   }
   
   // MARK: - Draw Methods
   
   override func draw(_ rect: CGRect) {
      // Drawing code
      
      NoodlesStyleKit.drawTimerAnimation(frame: self.bounds, resizing: .aspectFill, timerRatio: progress)
      
   }

}
