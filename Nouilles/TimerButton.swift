//
//  TimerButton.swift
//  Nouilles
//
//  Created by Denis Ricard on 2017-01-11.
//  Copyright © 2017 Hexaedre. All rights reserved.
//

import UIKit

/// TimerButton is a view used to display a custom button which changes
/// depending on the state of the timer (running or not). It override
/// the draw method with a PaintCode generated draw method
class TimerButton: UIView {

    // MARK: - Properties
    
    private var _buttonTextLabel: String = "Start Timer"
    
    var buttonLabel: String {
        
        set (newLabel) {
            _buttonTextLabel = newLabel
            setNeedsDisplay()
        }
        
        get {
            return _buttonTextLabel
        }
    }
    
    // MARK: - Draw Methods
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        NoodlesStyleKit.drawTimerButton(frame: self.bounds, timerButtonLabel: buttonLabel)
    }
    

}
