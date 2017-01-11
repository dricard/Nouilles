//
//  NoodleTimer.swift
//  Nouilles
//
//  Created by Denis Ricard on 2017-01-10.
//  Copyright © 2017 Hexaedre. All rights reserved.
//

import UIKit

/// This class represents a single timer with its associated data
/// it is created as the user starts timers for one or more noodles
/// and the list of running timers is kept in the Timers class
class NoodleTimer: NSObject {
    
    // MARK: - Properties
    
    var timer: Timer
    var secondsLeft: Int
    var cookingTime: Int
    var timerPaused: Bool = false
    var ringing: Bool = false
    var sound = Sound()

    private var minutes = 0
    private var seconds = 0

    init(cookingTime: Int) {
        // limit to under an hour cooking time. If it takes more than
        // 60 mn to cook it's not noodles...
        if cookingTime > 3600 {
            self.cookingTime = 3600
        } else {
            self.cookingTime = cookingTime
        }
        self.secondsLeft = self.cookingTime
        self.timer = Timer()
        super.init()
        // start timer as it's created
        self.startTimer()
    }
    
    func timerMinutesLabel() -> String {
        let spacerM = minutes < 10 ? "0" : ""
        return "\(spacerM)\(minutes)"
    }
    
    func timerSecondsLabel() -> String {
        let spacerS = seconds < 10 ? "0" : ""
        return "\(spacerS)\(seconds)"
    }
    
    func timerRatio() -> CGFloat {
        return CGFloat(1 - Double(secondsLeft) / Double(cookingTime))
    }
    
    func togglePauseTimer() -> Bool {
        timerPaused = !timerPaused
        return timerPaused
    }
    
    func isRunning() -> Bool {
        return !timerPaused
    }
    
    func isRinging() -> Bool {
        return ringing
    }
    
    func stopRing() {
        sound.stopRing()
    }
    
    func cancelTimer() {
        timerPaused = true
        stopTimer()
        // TODO: - need to do something to remove the timer object
        // TODO: - need to remove it also from the list of timers
    }
    
    // MARK: - Internal methods
    
    func updateTimer() {
        if secondsLeft > 0 {
            // decrement secondsLeft (we'll trigger this every second)
            if !timerPaused {
                secondsLeft -= 1
            }
            minutes = secondsLeft / 60
            seconds = secondsLeft % 60
            
        } else {
            stopTimer()
            playSound()
        }
        
    }

    func startTimer() {
        // invalidate any previously running timer, start a new timer
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(NoodleTimer.updateTimer), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        timer.invalidate()
    }
    
    private func playSound() {
        sound.playRing()
        ringing = true
    }

    
}
