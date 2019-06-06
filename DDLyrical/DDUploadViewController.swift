//
//  DDUploadViewController.swift
//  DDLyrical
//
//  Created by Gu Jun on 2019/5/11.
//  Copyright © 2019 Gu Jun. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import GCDWebServer.GCDWebUploader
import SpotlightLyrics

class DDUploadViewController: UIViewController, GCDWebUploaderDelegate {
    
    private let textLabel = UILabel()
    private let startOrStopButton = UIButton()
    private let supportedMediaTypes = ["mp3", "wav"]
    
    lazy private var uploadedMediaFiles = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(white: 0.98, alpha: 1)
        
        buildUI()
    }
    
    @objc func dismissVC() {
        DDWebServer.shared.stop()
        self.dismiss(animated: true) {
            //
            if self.uploadedMediaFiles.count > 0 {
                weak var weakSelf = self
                DispatchQueue.global().async {
                    DDLyricStore.shared.createMediaFiles(weakSelf!.uploadedMediaFiles)
                    
                    let manager = FileManager.default
                    let documentDirectory = manager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    let path = documentDirectory.absoluteString + "/" + "file" + ".lrc"
                    if manager.fileExists(atPath: path) {
                        weakSelf?.parseLrcFor(resource: "filename")
                    }
                }
            }
        }
    }
    
    @objc func startOrStopServer() {
        if DDWebServer.shared.isRunning() {
            DDWebServer.shared.stop()
            textLabel.text = String("server stopped")
            startOrStopButton.setTitle("Start Server", for: .normal)
        } else {
            let serverUrl = DDWebServer.shared.initWebUploader()
            textLabel.text = String(describing: "Visit " + serverUrl)
            startOrStopButton.setTitle("Stop Server", for: .normal)
            
            DDWebServer.shared.delegate = self
        }
    }
    
    private func buildUI() {
        let dismissButton = UIButton()
        dismissButton.setTitle("DISMISS", for: .normal)
        dismissButton.setTitleColor(.gray, for: .normal)
        self.view.addSubview(dismissButton)
        
        dismissButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        textLabel.text = "upload file via Wi-Fi"
        textLabel.textAlignment = .center
        self.view.addSubview(textLabel)
        
        startOrStopButton.backgroundColor = .gray
        startOrStopButton.setTitle("Start Server", for: .normal)
        self.view.addSubview(startOrStopButton)
        
        startOrStopButton.addTarget(self, action: #selector(startOrStopServer), for: .touchUpInside)
        
        dismissButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
//            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(100)
        }
        
        textLabel.snp.makeConstraints { (make) in
            make.top.equalTo(dismissButton.snp_bottom)
            make.right.equalToSuperview()
            make.bottom.equalTo(startOrStopButton.snp_top)
            make.left.equalToSuperview()
        }
        
        startOrStopButton.snp.makeConstraints { (make) in
            make.top.equalTo(textLabel.snp_bottom)
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
    deinit {
        print("deinit ", self)
    }
    
    // MARK: GCDWebUploaderDelegate
    
    func webUploader(_ uploader: GCDWebUploader, didDownloadFileAtPath path: String) {
        print("didDownloadFileAtPath: \(path)")
    }
    
    func webUploader(_ uploader: GCDWebUploader, didUploadFileAtPath path: String) {
        print("didUploadFileAtPath: \(path)")
        if let filename = path.components(separatedBy: "/").last {
            if supportedMediaTypes.contains(String(filename.suffix(3))) {
                uploadedMediaFiles.append(filename)
            }
        }
    }
    
    func webUploader(_ uploader: GCDWebUploader, didMoveItemFromPath fromPath: String, toPath: String) {
        print("didMoveItemFromPath: \(fromPath) toPath: \(toPath)")
    }
    
    func webUploader(_ uploader: GCDWebUploader, didDeleteItemAtPath path: String) {
        print("didDeleteItemAtPath: \(path)")
    }
    
    func webUploader(_ uploader: GCDWebUploader, didCreateDirectoryAtPath path: String) {
        print("didCreateDirectoryAtPath: \(path)")
    }
    
    // MARK: Pod SpotlightLyric
    
    private func parseLrcFor(resource: String) {
        do {
            let url = Bundle.main.url(forResource: resource, withExtension: "lrc")
            let lyricsString = try String.init(contentsOf: url!)
            let parser = LyricsParser(lyrics: lyricsString)
            
            // Now you get everything about the lyrics
            //            print(parser.header.title)
            //            print(parser.header.author)
            //            print(parser.header.album)
            
            var lines = Array<(time: Double, original: String, translation: String)>()
            
            for lyric in parser.lyrics {
                let pair = lyric.text.split(separator: " ")
                var original = ""
                var translation = ""
                if (pair.count == 2) {
                    original = String(pair[0])
                    translation = String(pair[1])
                } else if (pair.count == 3) {
                    original = String(pair[0]+pair[1])
                    translation = String(pair[2])
                } else if (pair.count == 4) {
                    original = String(pair[0]+pair[1])
                    translation = String(pair[2]+pair[3])
                } else {
                    print("Unexpected")
                    print(lyric.text)
                }
                lines.append((lyric.time, original, translation))
                //                print(lyric.text)
                //                print(lyric.time)
                //                timings.append(lyric.time)
            }
            
            let _ = DDLyricStore.shared.saveLyric(withFilename: "3098401105.mp3", lines: lines)
        } catch {
            print("ERROR: parse lrc")
        }
    }
}
