//
//  DDLyricalPlayer.swift
//  DDLyrical
//
//  Created by Gu Jun on 2019/4/23.
//  Copyright © 2019 Gu Jun. All rights reserved.
//

import UIKit
import AVFoundation

protocol DDLyricalPlayerDelegate: UIViewController {
    func focusOn(line: Int)
    func audioPlayerDidFinishPlaying()
}

class DDLyricalPlayer: NSObject, AVAudioPlayerDelegate {
    
    static let shared = DDLyricalPlayer()
    
    weak var delegate: DDLyricalPlayerDelegate?
    
    private static let TIMER_INTERVAL = 0.05
    
    private let fadeDuration = 0.2
    
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    private var timings: Array<Double> = Array<Double>()
    private var tempTimingIndex: Int = 0
    private var playingUUID: UUID?
    
    private override init() {
        
    }
    
    // MARK: AVAudioPlayerDelegate
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            delegate?.audioPlayerDidFinishPlaying()
        }
    }
    
    func loadSong(forResource filename: String, andTimings timings: Array<Double>, andUUID uuid: UUID) {
        
        let pair = filename.components(separatedBy: ".")
        assert(pair.count == 2)
        
        self.timings = timings

        let url = formURL(forResource: pair[0], withExtension: pair[1])
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.delegate = self
            audioPlayer?.enableRate = true
            
            playingUUID = uuid
        } catch {
            audioPlayer = nil
        }
    }
    
    func play() {
        audioPlayer?.setVolume(1, fadeDuration: fadeDuration)
        audioPlayer?.play()
        audioPlayer?.numberOfLoops = -1
        if audioPlayer?.currentTime == 0 {
            tempTimingIndex = 0
        }
        timer = Timer.scheduledTimer(timeInterval: DDLyricalPlayer.TIMER_INTERVAL, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }
    
    func pause() {
        audioPlayer?.setVolume(0, fadeDuration: fadeDuration)
        Timer.scheduledTimer(withTimeInterval: fadeDuration, repeats: false) { _ in
            self.audioPlayer?.pause()
        }
    }
    
    func nowPlayingUUID() -> UUID? {
        if audioPlayer != nil && audioPlayer!.isPlaying == true {
            return playingUUID
        }
        return nil
    }
    
    func isPlaying() -> Bool {
        if audioPlayer != nil && audioPlayer!.isPlaying == true {
            return true
        }
        return false
    }
    
    func setLoopMode(loopMode: DDLoopMode) {
        if audioPlayer == nil {
            return
        }
        switch loopMode {
        case .noLoop:
            audioPlayer!.numberOfLoops = 0
        case .loop:
            audioPlayer!.numberOfLoops = -1
        }
    }
    
    func setSpeed(rate: Float) {
        audioPlayer?.rate = rate
    }

    @objc func timerFired() {
        if (tempTimingIndex >= timings.count - 1) {
            timer?.invalidate()
            return
        }
        if let currentTime = audioPlayer?.currentTime {
            if (currentTime > timings[tempTimingIndex + 1]) {
                tempTimingIndex += 1
                delegate?.focusOn(line: tempTimingIndex)
            
//            for (index, timing) in timings.enumerated() {
//                if (currentTime > timing) {
//                    delegate?.focusOn(line: index)
//                    break
//                }
            }
        }
    }
    
    private func formURL(forResource filename: String, withExtension ext: String) -> URL {
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let fullpath = path + "/" + filename + "." + ext
        //        print(fullpath)
        let url = URL(fileURLWithPath: fullpath)

        return url
    }
    
    private func formURL(forBundleResource filename: String, withExtension ext: String) -> URL? {
        return Bundle.main.url(forResource: filename, withExtension: ext)
    }
}
