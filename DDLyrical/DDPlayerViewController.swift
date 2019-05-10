//
//  DDPlayerViewController.swift
//  DDLyrical
//
//  Created by Gu Jun on 2019/4/21.
//  Copyright © 2019 Gu Jun. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit
import MediaPlayer

class DDPlayerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DDLyricalPlayerDelegate {
    
    private let CellIdentifier = "LyricLineCellIdentifier"
    
    private let tableView = UITableView()
    private let tableHeader = UIView()
    private let playOrPauseButton = UIButton()
    
//    private var lyric = DDLyric()
    private var lines = Array<DDLine>()
    private var timings = Array<Double>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        getLyric()
        
        buildUI()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(DDLyricTableViewCell.self, forCellReuseIdentifier: CellIdentifier)
        
        DDLyricalPlayer.shared.delegate = self
        
        if !DDLyricalPlayer.shared.isPlaying() {
            DDLyricalPlayer.shared.loadSong(forResource: "3098401105", withExtension: "mp3", andTimings: timings)
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
            
        }
        
//        DDWebServer.shared.initWebUploader()
        
        setPlayingInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.resignFirstResponder()
        UIApplication.shared.endReceivingRemoteControlEvents()
    }
    
    // MARK: DDLyricalPlayerDelegate
    
    func focusOn(line: Int) {
        tableView.scrollToRow(at: IndexPath(row: line, section: 0), at: .middle, animated: true)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as! DDLyricTableViewCell
        let line = lines[indexPath.row]
        cell.originalView.text = line.original
        cell.translationView.text = line.translation
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIScreen.main.bounds.size.height / 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    // MARK: button events
    
    @objc private func playOrPause() {
        if DDLyricalPlayer.shared.isPlaying() {
            DDLyricalPlayer.shared.pause()
            playOrPauseButton.setTitle("Play", for: .normal)
        } else {
            DDLyricalPlayer.shared.play()
            playOrPauseButton.setTitle("Pause", for: .normal)
        }
    }
    
    @objc private func pause() {
    }
    
    // MARK: private func
    
    private func buildUI() {
        view.addSubview(tableView)
        
        let controlPanel = UIView()
        controlPanel.backgroundColor = .gray
        view.addSubview(controlPanel)
        
        let loopButton = UIButton()
        let modeButton = UIButton()
        loopButton.setTitle("Loop", for: .normal)
        loopButton.titleLabel?.textColor = .white
        playOrPauseButton.setTitle("Play", for: .normal)
        playOrPauseButton.titleLabel?.textColor = .white
        modeButton.setTitle("Single", for: .normal)
        modeButton.titleLabel?.textColor = .white
        controlPanel.addSubview(loopButton)
        controlPanel.addSubview(playOrPauseButton)
        controlPanel.addSubview(modeButton)
        
//        loopButton.addTarget(self, action: #selector(playOrPause), for: .touchUpInside)
        playOrPauseButton.addTarget(self, action: #selector(playOrPause), for: .touchUpInside)
        
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
        
        loopButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalTo(playOrPauseButton.snp_left)
            
            make.width.equalTo(playOrPauseButton.snp_width)
            make.width.equalTo(modeButton.snp_width)
        }
        
        playOrPauseButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalTo(modeButton.snp_left)
            make.bottom.equalToSuperview()
            make.left.equalTo(loopButton.snp_right)
//            make.width.equalTo(UIScreen.main.bounds.size.width * 0.5)
        }
        
        modeButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalTo(playOrPauseButton.snp_right)
//            make.width.equalTo(UIScreen.main.bounds.size.width * 0.5)
        }
        
    }
    
    private func getLyric() {
        let lyric = DDLyricStore.shared.getLyric(by: UUID())
        
        var lines = Array<DDLine>()
        var timings = Array<Double>()
        for item in lyric!.lines! {
            let itemLine = item as! DDLine
            lines.append(itemLine)
            timings.append(itemLine.time)
        }
        self.lines = lines
        self.timings = timings
    }
    
    private func setPlayingInfo() {
        var nowPlayingInfo = [String:Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = "title"
        nowPlayingInfo[MPMediaItemPropertyArtist] = "artist"
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = 300
        let image = UIImage(named: "artwork")!
        nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: image)
//        MPMediaItemArtwork(boundsSize: <#T##CGSize#>, requestHandler: <#T##(CGSize) -> UIImage#>)

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        if (event!.type == .remoteControl) {
            switch (event!.subtype) {
            case .remoteControlPlay: DDLyricalPlayer.shared.play();break
            case .remoteControlStop: DDLyricalPlayer.shared.pause();break
            case .remoteControlNextTrack: break
            case .remoteControlPreviousTrack: break
            default: break
            }
        }
    }
    
    deinit {
        print("deinit ", self)
    }
}
