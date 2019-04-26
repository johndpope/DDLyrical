//
//  DDPlayerViewController.swift
//  DDLyrical
//
//  Created by Gu Jun on 2019/4/21.
//  Copyright © 2019 Gu Jun. All rights reserved.
//

import UIKit
import AVFoundation
import SpotlightLyrics
import SnapKit

class DDPlayerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let CellIdentifier = "LyricLineCellIdentifier"
    
    let tableView = UITableView()
    
    var lyric = DDLyric()
    private var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        buildUI()
        
        tableView.delegate = self
        tableView.dataSource = self
        mockdata()
        
        tableView.register(DDLyricTableViewCell.self, forCellReuseIdentifier: CellIdentifier)
        
        player()
        
        testParser()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lyric.lines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as! DDLyricTableViewCell
        let line = lyric.lines[indexPath.row]
        cell.originalView.text = line.original
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    private func buildUI() {
        view.addSubview(tableView)
        
        let controlPanel = UIView()
        controlPanel.backgroundColor = .gray
        view.addSubview(controlPanel)
        
        let playButton = UIButton()
        let pauseButton = UIButton()
        playButton.setTitle("Play", for: .normal)
        playButton.titleLabel?.textColor = .white
        pauseButton.setTitle("Pause", for: .normal)
        pauseButton.titleLabel?.textColor = .white
        controlPanel.addSubview(playButton)
        controlPanel.addSubview(pauseButton)
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(controlPanel.snp.top)
        }
        
        controlPanel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.size.height * 0.15)
        }
        
        playButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.size.width * 0.5)
        }
        
        pauseButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.size.width * 0.5)
        }
        playButton.addTarget(self, action: #selector(play), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pause), for: .touchUpInside)
        
    }
    
    @objc private func play() {
        audioPlayer?.play()
    }
    
    @objc private func pause() {
        audioPlayer?.pause()
    }
    
    private func mockdata() {
    }
    
    private func player() {
        let url = Bundle.main.url(forResource: "3098401105", withExtension: "mp3")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url!)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            audioPlayer = nil
        }
    }
    
    private func testParser() {
        do {
            let url = Bundle.main.url(forResource: "クリスマスソング", withExtension: "lrc")
            let lyricsString = try String.init(contentsOf: url!)
            let parser = LyricsParser(lyrics: lyricsString)
            
            // Now you get everything about the lyrics
//            print(parser.header.title)
//            print(parser.header.author)
//            print(parser.header.album)
            
            for lyric in parser.lyrics {
                let line = DDLyricLine()
                line.time = lyric.time
                line.original = lyric.text
                self.lyric.lines.append(line)
//                print(lyric.text)
//                print(lyric.time)
            }
        } catch {
            print("ERROR: parse lrc")
        }
    }
}
