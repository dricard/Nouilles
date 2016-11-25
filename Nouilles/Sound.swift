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
   
   var audioPlayer: AVAudioPlayer!
   var audioEngine: AVAudioEngine!
   var timer: Timer?
   
   override init() {
      
      let url = Bundle.main.url(forResource: "scanBeep", withExtension: "mp3")!
      
      do {
         self.audioPlayer = try AVAudioPlayer.init(contentsOf: url)
         
      } catch let error as NSError {
         print("Could not create audioPlayer \(error), \(error.userInfo)")
      }
      audioEngine = AVAudioEngine()
      
      super.init()
   }
   
   func playSound() {
      
      audioPlayer.play()
      startTimer()
      
   }
   
   func startTimer() {
      // invalidate any previously running timer, start a new timer
      timer?.invalidate()
      timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(Sound.stopSound), userInfo: nil, repeats: true)
   }

   func stopSound() {
      audioPlayer.stop()
      audioEngine.stop()
      audioEngine.reset()
   }

}
