//
//  TimerView.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-11-21.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit

/// TimerViewWithLabels is used to display the timer progress circle by overriding
/// the draw method with a call to a PainCode generated draw method
/// This can be used in views of various size (in the list view, or its
/// own VC). This version has minutes and seconds labels
class TimerViewWithLabels: UIView {
    
    // MARK: - Properties
    
    private var ratio: CGFloat = 0.0
    private var _minutesLabel = ""
    private var _secondsLabel = ""
    
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

    var minutesLabel: String {
        set (newLabel) {
            _minutesLabel = newLabel
            setNeedsDisplay()
        }
        get {
            return _minutesLabel
        }
    }

    var secondsLabel: String {
        set (newLabel) {
            _secondsLabel = newLabel
            setNeedsDisplay()
        }
        get {
            return _secondsLabel
        }
    }
    
    // MARK: - Draw Methods
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        NoodlesStyleKit.drawTimerAnimationWithTime(frame: self.bounds, resizing: .aspectFill, timerRatio: progress, minutes: minutesLabel, seconds: secondsLabel)
    }
    
}
