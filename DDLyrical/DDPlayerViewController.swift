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

enum DDLoopMode {
    case noLoop
    case loop
}

class DDPlayerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DDLyricalPlayerDelegate {
    
    var filename: String?
    
    
    private let CellIdentifier = "LyricLineCellIdentifier"
    
    private let tableView = UITableView()
    private let tableHeader = UIView()
    private let playOrPauseButton = UIButton()
    private let loopButton = UIButton()
    private let speedButton = UIButton()
    
//    private var lyric = DDLyric()
    private var lines = Array<DDLine>()
    private var timings = Array<Double>()
    private var loopMode: DDLoopMode = .loop
    private var speedRate = 1.0
    private var lyric: DDLyric?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        assert(filename != nil)
        let pair = filename!.split(separator: ".")
        assert(pair.count == 2)
        
        buildUI()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.register(DDLyricTableViewCell.self, forCellReuseIdentifier: CellIdentifier)
        
        DDLyricalPlayer.shared.delegate = self
        DDLyricalPlayer.shared.setLoopMode(loopMode: .loop)
        
        getLyric()
        if let nowPlaying = DDLyricalPlayer.shared.nowPlaying() {
            if nowPlaying != String(pair[0]) {
                DDLyricalPlayer.shared.loadSong(forResource: String(pair[0]), withExtension: String(pair[1]), andTimings: timings)
            }
        } else {
            DDLyricalPlayer.shared.loadSong(forResource: String(pair[0]), withExtension: String(pair[1]), andTimings: timings)
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
            
        }
        
        setPlayingInfo()
        
        id3v2()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if DDLyricalPlayer.shared.isPlaying() {
            playOrPauseButton.setTitle("Pause", for: .normal)
        } else {
            playOrPauseButton.setTitle("Play", for: .normal)
        }
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
        _ = tableView.visibleCells.map { (cell) in
            if cell.tag != line {
                (cell as! DDLyricTableViewCell).setThemeColor(.gray)
            } else {
                (cell as! DDLyricTableViewCell).setThemeColor(.black)
            }
        }
        tableView.scrollToRow(at: IndexPath(row: line, section: 0), at: .middle, animated: true)
    }
    
    func audioPlayerDidFinishPlaying() {
        self.playOrPauseButton.setTitle("Play", for: .normal)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as! DDLyricTableViewCell
        cell.tag = indexPath.row
        
        let line = lines[indexPath.row]
        
//        let (segments, annotations) = self.parse(line: line.original!)
        var segments = [String]()
        for item in line.segments! {
            segments.append((item as! DDSegment).segment!)
        }
        cell.segments = segments
        
        cell.translationView.text = line.translation
        
        var annotations = [DDLyricAnnotation]()
        for item in line.annotations! {
            let anno = item as! DDAnnotation
            let annotation = DDLyricAnnotation()
            annotation.start = Int(anno.begin)
            annotation.end = Int(anno.end)
            annotation.furigana = anno.text!
            annotation.segmentIndex = Int(anno.segmentIndex)
            annotations.append(annotation)
        }
        cell.annotations = annotations
        
        cell.buildAnnotations()
        
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
    
    @objc private func changeLoop() {
        switch self.loopMode {
        case .noLoop:
            self.loopMode = .loop
            self.loopButton.setTitle("Loop", for: .normal)
            DDLyricalPlayer.shared.setLoopMode(loopMode: .loop)
        case .loop:
            self.loopMode = .noLoop
            self.loopButton.setTitle("Once", for: .normal)
            DDLyricalPlayer.shared.setLoopMode(loopMode: .noLoop)
        }
    }
    
    @objc private func changeSpeed() {
        switch self.speedRate {
        case 1.0:
            self.speedRate = 0.5
            self.speedButton.setTitle("0.5x", for: .normal)
            DDLyricalPlayer.shared.setSpeed(rate: 0.5)
        case 0.5:
            self.speedRate = 1.0
            self.speedButton.setTitle("1x", for: .normal)
            DDLyricalPlayer.shared.setSpeed(rate: 1)
        default:
            self.speedRate = 1.0
            self.speedButton.setTitle("1x", for: .normal)
            DDLyricalPlayer.shared.setSpeed(rate: 1)
        }
    }
    
    // MARK: private func
    
    private func buildUI() {
        view.addSubview(tableView)
        
        let controlPanel = UIView()
        controlPanel.backgroundColor = .init(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        view.addSubview(controlPanel)
        
        loopButton.setTitle("Loop", for: .normal)
        loopButton.tintColor = .init(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        playOrPauseButton.setTitle("Play", for: .normal)
        playOrPauseButton.titleLabel?.textColor = .white
        speedButton.setTitle("1x", for: .normal)
        speedButton.titleLabel?.textColor = .white
        controlPanel.addSubview(loopButton)
        controlPanel.addSubview(playOrPauseButton)
        controlPanel.addSubview(speedButton)
        
        loopButton.addTarget(self, action: #selector(changeLoop), for: .touchUpInside)
        playOrPauseButton.addTarget(self, action: #selector(playOrPause), for: .touchUpInside)
        speedButton.addTarget(self, action: #selector(changeSpeed), for: .touchUpInside)
        
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
            make.width.equalTo(speedButton.snp_width)
        }
        
        playOrPauseButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalTo(speedButton.snp_left)
            make.bottom.equalToSuperview()
            make.left.equalTo(loopButton.snp_right)
//            make.width.equalTo(UIScreen.main.bounds.size.width * 0.5)
        }
        
        speedButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalTo(playOrPauseButton.snp_right)
//            make.width.equalTo(UIScreen.main.bounds.size.width * 0.5)
        }
        
    }
    
    private func getLyric() {
        lyric = DDLyricStore.shared.getLyric(by: UUID())
        
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
        nowPlayingInfo[MPMediaItemPropertyTitle] = lyric?.name ?? "title"
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
    
    
    private func id3v2() {
        let url = Bundle.main.url(forResource: "クリスマスソング", withExtension: "mp3")!
        let asset: AVAsset = AVAsset(url: url)
//        for item in asset.availableMetadataFormats {
//            print(item)
//        }
        for metadataItem in asset.metadata {
            print(metadataItem.commonKey!.rawValue)
        }
    }
}
