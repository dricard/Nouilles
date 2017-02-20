//
//  TimerVC.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-11-21.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

/*
 This displays a timer for the noodle. User can pause/restart
 the timer as well as discard it.
 
 The user can move out of this VC and return, with a timer
 running.
 
 */


import UIKit

class TimerVC: UIViewController {
    
    // MARK: - Properties
    
    var timers: Timers?
    var nouille: Nouille?
    var noodleTimer: NoodleTimer?
    var cancelTR = UITapGestureRecognizer()
    var pauseTapRec = UITapGestureRecognizer()
    var internalTimer = Timer()
    
    // MARK: - Outlets
    
    @IBOutlet weak var timerView: TimerView!
    @IBOutlet weak var minutesTimerLabel: UILabel!
    @IBOutlet weak var secondsTimerLabel: UILabel!
    @IBOutlet weak var pausePlayView: UIImageView!
    @IBOutlet weak var cancelView: UIImageView!
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // theme related
        view.backgroundColor = NoodlesStyleKit.lighterYellow
        timerView.backgroundColor = NoodlesStyleKit.lighterYellow
        
        // add gesture recognizer on cancelView so user can cancel timer
        cancelTR.addTarget(self, action: #selector(TimerVC.cancelTapped))
        cancelView.addGestureRecognizer(cancelTR)
        
        // add gesture recognizer on pausePlayView so user can pause/play timer
        pauseTapRec.addTarget(self, action: #selector(TimerVC.pauseTapped))
        pausePlayView.addGestureRecognizer(pauseTapRec)
        
        // set cancel button image
        cancelView.image = NoodlesStyleKit.imageOfCancel
        
        // register for notification observer
        NotificationCenter.default.addObserver(self, selector: #selector(TimerVC.didBecomeActive), name: .UIApplicationDidBecomeActive, object: nil)
        
        // update display depending on state of timer
        if let noodleTimer = noodleTimer {
            // set to pause/pause image (depending on state)
            if noodleTimer.isRunning() {
                pausePlayView.image = NoodlesStyleKit.imageOfPause
            } else {
                pausePlayView.image = NoodlesStyleKit.imageOfPlay
            }
        }
    }
    
    // We may have come back to the foreground/active and a notification
    // for this timer was tapped by the user, in which case the timer is
    // over and was set to zero in AppDelegate.userNotificationCenter(:didReceive:)
    // This means the user was alerted, and tapped the notification
    func didBecomeActive() {
        if let noodleTimer = noodleTimer {
            if noodleTimer.secondsLeft == 0 {
                cancelTapped(self)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // update display once to current state on entry
        if let noodleTimer = noodleTimer {
            minutesTimerLabel.text = noodleTimer.timerMinutesLabel()
            secondsTimerLabel.text = noodleTimer.timerSecondsLabel()
            timerView.progress = noodleTimer.timerRatio()
        }
        // start an internal timer which is responsible to update the display
        DispatchQueue.main.async {
            self.internalTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(TimerVC.updateTimerLabel), userInfo: nil, repeats: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        internalTimer.invalidate()
    }
    
    // MARK: - Utilities
    
    func updateTimerLabel() {
        guard let noodleTimer = noodleTimer else { return }
        if noodleTimer.secondsLeft == 0 {
            cancelTapped(self)
        }
        if noodleTimer.isRunning() {
            minutesTimerLabel.text = noodleTimer.timerMinutesLabel()
            secondsTimerLabel.text = noodleTimer.timerSecondsLabel()
            timerView.progress = noodleTimer.timerRatio()
        }
    }
    
    // MARK: - Actions
    
    func cancelTapped(_ sender: Any) {
        // cancel internal timer which is used to update the display
        internalTimer.invalidate()
        guard let noodleTimer = noodleTimer else { return }
        // invalidate the noodle timer itself
        noodleTimer.cancelTimer()
        // stop the ringing sound if playing
        if noodleTimer.isRinging() {
            noodleTimer.stopRing()
        }
        // remove the timer from the list
        if let timers = timers, let nouille = nouille {
            timers.deleteTimerFor(noodle: nouille)
        }
        // segue out back to detailed view
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func pauseTapped(_ sender: Any) {
        guard let noodleTimer = noodleTimer else { return }
        if noodleTimer.togglePauseTimer() {
            pausePlayView.image = NoodlesStyleKit.imageOfPlay
            updateTimerLabel()
        } else {
            pausePlayView.image = NoodlesStyleKit.imageOfPause
        }
        if noodleTimer.isRinging() {
            noodleTimer.stopRing()
        }
    }
}
