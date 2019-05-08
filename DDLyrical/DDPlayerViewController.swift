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
//        tableHeader.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        DDLyricalPlayer.shared.delegate = self
        
        DDLyricalPlayer.shared.loadSong(forResource: "3098401105", withExtension: "mp3", andTimings: timings)
        
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
            
        }
        
//        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: true)
        
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
        var dic = [String:String]()
        dic[MPMediaItemPropertyTitle] = "title"
        dic[MPMediaItemPropertyArtist] = "artist"
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = dic
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
}
