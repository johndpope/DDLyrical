//
//  DDLyricalPlayer.swift
//  DDLyrical
//
//  Created by Gu Jun on 2019/4/23.
//  Copyright © 2019 Gu Jun. All rights reserved.
//

import UIKit
import AVFoundation

class DDLyricalPlayer: NSObject {
    
    static let shared = DDLyricalPlayer()
    
    private var audioPlayer: AVAudioPlayer?
    
    private override init() {
    }
    
    func prepareToPlay() {
        let url = Bundle.main.url(forResource: "3098401105", withExtension: "mp3")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url!)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            audioPlayer = nil
        }
    }
    
    func play() {
        audioPlayer?.play()
    }
    
    func pause() {
        audioPlayer?.pause()
    }

}
