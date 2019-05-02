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

class DDPlayerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DDLyricalPlayerDelegate {
    
    private let CellIdentifier = "LyricLineCellIdentifier"
    
    private let tableView = UITableView()
    private let tableHeader = UIView()
    
    private var lyric = DDLyric()
    private var timings = Array<Double>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        buildUI()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(DDLyricTableViewCell.self, forCellReuseIdentifier: CellIdentifier)
//        tableHeader.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        DDLyricalPlayer.shared.delegate = self
        
        testParser()
        DDLyricalPlayer.shared.loadSong(forResource: "3098401105", withExtension: "mp3", andTimings: timings)
        
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
            
        }
        
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: true)
        
        DDWebServer.shared.initWebServer()
    }
    
    
    func focusOn(line: Int) {
        tableView.scrollToRow(at: IndexPath(row: line, section: 0), at: .middle, animated: true)
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIScreen.main.bounds.size.height / 2
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
        
        playButton.addTarget(self, action: #selector(play), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pause), for: .touchUpInside)
        
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
        
    }
    
    @objc private func play() {
        DDLyricalPlayer.shared.play()
    }
    
    @objc private func pause() {
        DDLyricalPlayer.shared.pause()
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
                timings.append(lyric.time)
            }
        } catch {
            print("ERROR: parse lrc")
        }
    }
    
}
