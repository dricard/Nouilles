//
//  Sound.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-11-24.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

/*  This is responsible to play sounds for the UI
 beep is used when a barcode scan was successful
 ring is played when a cooking timer expires
 */

import Foundation
import AVFoundation
import AudioToolbox

class Sound: NSObject {
    
    // MARK: - Properties
    
    var beepPlayer: AVAudioPlayer!
    var ringPlayer: AVAudioPlayer!
    var audioEngine: AVAudioEngine!
    var timer: Timer?
    var soundID: SystemSoundID
    
    override init() {
        
        // Sound resources urls
        let beepUrl = Bundle.main.url(forResource: "scanBeep", withExtension: "mp3")!
        let ringUrl = Bundle.main.url(forResource: "ringSound", withExtension: "mp3")!
        
        // for the timer ring we use system sound so it can play from any VC
        soundID = SystemSoundID(Int64(NSDate().timeIntervalSince1970))
        _ = AudioServicesCreateSystemSoundID(ringUrl as CFURL, &soundID)

        do {
            self.beepPlayer = try AVAudioPlayer.init(contentsOf: beepUrl)
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
        AudioServicesPlaySystemSound(soundID)
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
        _ = AudioServicesDisposeSystemSoundID(soundID)
    }
    
}
