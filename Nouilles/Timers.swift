//
//  Timers.swift
//  Nouilles
//
//  Created by Denis Ricard on 2017-01-10.
//  Copyright © 2017 Hexaedre. All rights reserved.
//

import UIKit

/// This class holds NoodleTimer objects to track the various
/// timers that can run simultaneously. The are displayed both
/// in a dedicated timerVC or as a replacement for the noddle image
/// in the list view if a timer is running.
class Timers: NSObject {

    // MARK: - properties
    
    var timers = [String:NoodleTimer]()
    
    // This array of tuples is used for sequence-type access in list view
    var timersArray = [(String, NoodleTimer)]()
    
    // MARK: - methods
    
    // check if a timer is associated with a specific noodle
    // we associate timers with the noodle 'name' property, which is unique
    
    func hasTimerFor(noodle: Nouille) -> Bool {
        guard let name = noodle.name else { return false }
        return timers[name] != nil
    }
    
    func isNotEmpty() -> Bool {
        return !timers.isEmpty
    }
    
    func createTimerFor(noodle: Nouille) {
        guard let name = noodle.name, let time = noodle.time else { return }
        let seconds = Int(Double(time) * 60.0)
        let noodleTimer = NoodleTimer(cookingTime: seconds)
        noodleTimer.delegate = self
        timers[name] = noodleTimer
        // now add it to the array for sequence-type access in list view
        timersArray.append((name, noodleTimer))
    }
    
    func timerFor(noodle: Nouille) -> NoodleTimer? {
        guard let name = noodle.name else { return nil }
        return timers[name]
    }
    
    func deleteTimerFor(noodle: Nouille) {
        guard let name = noodle.name else { return }
        timers[name] = nil
        // Now also remove it from the array
        for (index, (nameAtIndex, _)) in timersArray.enumerated() {
            if nameAtIndex == name {
                timersArray.remove(at: index)
            }
        }
    }
    
}

extension Timers: NoodleTimerDelegate {
    
    func removeTimerFromList(noodleTimer: NoodleTimer) {
        for (name, timer) in timers {
            if timer == noodleTimer {
                timers[name] = nil
            }
        }
    }
}
