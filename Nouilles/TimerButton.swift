//
//  TimerButton.swift
//  Nouilles
//
//  Created by Denis Ricard on 2017-01-11.
//  Copyright © 2017 Hexaedre. All rights reserved.
//

import UIKit

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
