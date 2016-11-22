//
//  TimerVC.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-11-21.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit

class TimerVC: UIViewController {
   
   // MARK: - Properties
   
   var cookingTime: Int = 0
   var secondsLeft: Int = 0
   var minutes = 0
   var seconds = 0
   var timer: Timer?
   var timerPaused = true
   
   // MARK: - Outlets
   
   @IBOutlet weak var timerView: TimerView!
   @IBOutlet weak var minutesTimerLabel: UILabel!
   @IBOutlet weak var secondsTimerLabel: UILabel!
   @IBOutlet weak var cancelButton: UIButton!
   @IBOutlet weak var pauseButton: UIButton!
   
   
   // MARK: - Life Cycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // limit to under an hour cooking time. If it takes more than
      // 60 mn to cook it's not noodles...
      if cookingTime > 3600 { cookingTime = 3600 }
      secondsLeft = cookingTime
      // on load, timerPaused is true so this will initiate
      // the time display
      updateTimerLabel()
      // now unpause the timer
      timerPaused = false
      startTimer()
      
   }
   
   override func viewDidDisappear(_ animated: Bool) {
      // invalidate timer before leaving
      timer?.invalidate()

   }
   // MARK: - Utilities
   
   func updateTimerLabel() {
      
      if secondsLeft > 0 {
         // decrement secondsLeft (we'll trigger this every second)
         if !timerPaused {
            secondsLeft -= 1
         }
         minutes = secondsLeft / 60
         seconds = secondsLeft % 60
         let spacer = seconds < 10 ? "0" : ""
         minutesTimerLabel.text = "\(minutes)"
         secondsTimerLabel.text = "\(spacer)\(seconds)"
         let ratio = 1 - Double(secondsLeft) / Double(cookingTime)
         timerView.progress = CGFloat(ratio)
         
      } else {
         
         stopTimer()
      }
   }
   
   func startTimer() {
      print("In start Timer")
      // invalidate any previously running timer, start a new timer
      timer?.invalidate()
      timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(TimerVC.updateTimerLabel), userInfo: nil, repeats: true)
      
   }
   
   func stopTimer() {
      timer?.invalidate()
      minutesTimerLabel.text = "00"
      secondsTimerLabel.text = "00"
   }
   
   func pauseTimer() {
   }
   
   // MARK: - Actions
   
   @IBAction func cancelTapped(_ sender: Any) {
      stopTimer()
   }
   
   @IBAction func pauseTapped(_ sender: Any) {
      timerPaused = !timerPaused
   }
   
   
}
