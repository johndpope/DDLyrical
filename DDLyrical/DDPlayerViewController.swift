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
    
    var filename: String?
    
    
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
        
        assert(filename != nil)
        let pair = filename!.split(separator: ".")
        assert(pair.count == 2)
        
        buildUI()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(DDLyricTableViewCell.self, forCellReuseIdentifier: CellIdentifier)
        
        DDLyricalPlayer.shared.delegate = self
        
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
//        tableView.scrollToRow(at: IndexPath(row: line, section: 0), at: .middle, animated: true)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as! DDLyricTableViewCell
        let line = lines[indexPath.row]
        
        let (segments, annotations) = self.parse(line: line.original!)
        
        cell.segments = segments
        cell.translationView.text = line.translation
        
//        let annotation = DDLyricAnnotation()
//        annotation.start = 1
//        annotation.end = 2
//        annotation.furigana = "い"
//        let annotations = [annotation]
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
    
    @objc private func pause() {
    }
    
    // MARK: private func
    
    private func buildUI() {
        view.addSubview(tableView)
        
        let controlPanel = UIView()
        controlPanel.backgroundColor = .gray
        view.addSubview(controlPanel)
        
        let loopButton = UIButton()
        let playlistButton = UIButton()
        loopButton.setTitle("Loop", for: .normal)
        loopButton.tintColor = .white
        playOrPauseButton.setTitle("Play", for: .normal)
        playOrPauseButton.titleLabel?.textColor = .white
        playlistButton.setTitle("Playlist", for: .normal)
        playlistButton.titleLabel?.textColor = .white
        controlPanel.addSubview(loopButton)
        controlPanel.addSubview(playOrPauseButton)
        controlPanel.addSubview(playlistButton)
        
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
            make.width.equalTo(playlistButton.snp_width)
        }
        
        playOrPauseButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalTo(playlistButton.snp_left)
            make.bottom.equalToSuperview()
            make.left.equalTo(loopButton.snp_right)
//            make.width.equalTo(UIScreen.main.bounds.size.width * 0.5)
        }
        
        playlistButton.snp.makeConstraints { (make) in
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
    
    private func test_parse() {
        let (segments, annotations) = parse(line: "どこかで鐘(かね)が鳴って")
        print(segments)
        print(annotations)
    }
    
    private func parse(line: String) -> (segments: [String], annotations: [DDLyricAnnotation]) {
        var segments = Array<String>()
        var annotations = Array<DDLyricAnnotation>()
        
        var segment = ""
        var goingOnType: CharacterType = .kana
        var startingKanjiIndex = 0
        var endingKanjiIndex = 0
        for (index, item) in line.unicodeScalars.enumerated() {
            var charType: CharacterType = .kana
            if (item.description == "(" || item.description == "（") {
                charType = .startingBracket
            } else if (item.description == ")" || item.description == "）") {
                charType = .endingBracket
            } else if (isKana(str: item.description)) {
                charType = .kana
            } else if (isKanji(str: item.description)) {
                charType = .kanji
            } else {
                print(item)
                charType = .other
            }
            
            if (index == 0) {
                segment = item.description
                goingOnType = charType
                
                if (line.unicodeScalars.count == 1) {
                    segments.append(segment)
                    return (segments, annotations)
                } else {
                    continue
                }
            }
            
            if (charType == goingOnType) {
                segment += item.description
            } else if (charType == .kana && goingOnType != .kana) {
                if (goingOnType == .kanji) {
                    segments.append(segment)
                }
                
                segment = item.description
            } else if (charType == .kanji && goingOnType != .kanji) {
                startingKanjiIndex = index
                segments.append(segment)
                
                segment = item.description
            } else if (charType == .startingBracket) {
                segments.append(segment)
                segment = ""
                endingKanjiIndex = index - 1
            } else if (charType == .endingBracket) {
                let annotation = DDLyricAnnotation()
                annotation.start = startingKanjiIndex
                annotation.end = endingKanjiIndex
                annotation.furigana = segment
                annotations.append(annotation)
                
                startingKanjiIndex = 0
                endingKanjiIndex = 0
                segment = ""
            } else if (charType == .other) {
                print(index, item)
            } else {
                print(index, item)
            }
            goingOnType = charType
            
            if (index == line.unicodeScalars.count - 1) {
                segments.append(segment)
            }
            print(item)
        }
        
        return (segments, annotations)
    }
    
    private func test_isKana() {
        print(isKana(str: "🐶"))
        print(isKana(str: "い"))
        print(isKana(str: "カ"))
        print(isKana(str: "中"))
        print(isKana(str: "鐘"))
    }
    
    private func test_isKanji() {
        print(isKanji(str: "🐶"))
        print(isKanji(str: "い"))
        print(isKanji(str: "カ"))
        print(isKanji(str: "中"))
        print(isKanji(str: "鐘"))
    }
    
    private func isKana(str: String) -> Bool {
        //        let pattern = "^[\\u3040-\\u309F]+|$"
        let pattern = "[ぁ-ん]+|[ァ-ヴー]+"
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options(rawValue: 0)) else {
            return false
        }
        
        // range: 检验传入字符串str的哪些部分,此处为全部
        let result: Int = regex.numberOfMatches(in: str,
                                                options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                                range: NSMakeRange(0, str.count))
        return result > 0
        
    }
    
    private func isKanji(str: String) -> Bool {
        if str.unicodeScalars.count != 1 {
            assertionFailure()
        }
        let pattern = "[一-龠]+"
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options(rawValue: 0)) else {
            return false
        }
        
        // range: 检验传入字符串str的哪些部分,此处为全部
        let result: Int = regex.numberOfMatches(in: str,
                                                options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                                range: NSMakeRange(0, str.count))
        return result > 0
    }
}
