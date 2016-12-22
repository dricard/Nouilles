//
//  Sound.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-11-24.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import Foundation
import AVFoundation

class Sound: NSObject {
   
   // MARK: - Properties
   
   var beepPlayer: AVAudioPlayer!
   var ringPlayer: AVAudioPlayer!
   var audioEngine: AVAudioEngine!
   var timer: Timer?
   
   override init() {
      
      let beepUrl = Bundle.main.url(forResource: "scanBeep", withExtension: "mp3")!
      let ringUrl = Bundle.main.url(forResource: "ringSound", withExtension: "mp3")!
      
      do {
         self.beepPlayer = try AVAudioPlayer.init(contentsOf: beepUrl)
         self.ringPlayer = try AVAudioPlayer.init(contentsOf: ringUrl)
         
      } catch let error as NSError {
         print("Could not create audioPlayer \(error), \(error.userInfo)")
      }
      audioEngine = AVAudioEngine()
      
      super.init()
   }
   
   func playBeep() {
      
      beepPlayer.play()
      startTimer()
      
   }
   
   func playRing() {
      
      ringPlayer.play()
      
   }
   
   func startTimer() {
      // invalidate any previously running timer, start a new timer
      timer?.invalidate()
      timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(Sound.stopBeep), userInfo: nil, repeats: true)
   }

   func stopBeep() {
      beepPlayer.stop()
      audioEngine.stop()
      audioEngine.reset()
   }

   func stopRing() {
      ringPlayer.stop()
      audioEngine.stop()
      audioEngine.reset()
   }

}
