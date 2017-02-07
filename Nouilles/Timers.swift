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
    
    var timers = [Int:NoodleTimer]()
    
    // This array of tuples is used for sequence-type access in list view
    var timersArray = [(Int, NoodleTimer)]()
    
    // MARK: - methods
    
    // check if a timer is associated with a specific noodle
    // we associate timers with the noodle 'name' property, which is unique
    
    func hasTimerFor(noodle: Nouille) -> Bool {
        return timers[noodle.objectID.hashValue] != nil
    }
    
    func isNotEmpty() -> Bool {
        return !timers.isEmpty
    }
    
    func createTimerFor(noodle: Nouille) {
        guard let time = noodle.time else { return }
        let seconds = Int(Double(time) * 60.0)
        let noodleTimer = NoodleTimer(cookingTime: seconds)
        noodleTimer.delegate = self
        timers[noodle.objectID.hashValue] = noodleTimer
        // now add it to the array for sequence-type access in list view
        timersArray.append((noodle.objectID.hashValue, noodleTimer))
    }
    
    func timerFor(noodle: Nouille) -> NoodleTimer? {
        return timers[noodle.objectID.hashValue]
    }
    
    func deleteTimerFor(noodle: Nouille) {
        timers[noodle.objectID.hashValue] = nil
        // Now also remove it from the array
        for (index, (objectID, _)) in timersArray.enumerated() {
            if objectID == noodle.objectID.hashValue {
                timersArray.remove(at: index)
            }
        }
    }
    
}

extension Timers: NoodleTimerDelegate {
    
    func removeTimerFromList(noodleTimer: NoodleTimer) {
        for (objectID, _timer) in timers {
            if _timer == noodleTimer {
                timers[objectID] = nil
            }
        }
    }
}
