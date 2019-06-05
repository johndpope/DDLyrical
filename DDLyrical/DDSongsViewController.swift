//
//  DDSongsViewController.swift
//  DDLyrical
//
//  Created by Gu Jun on 2019/5/8.
//  Copyright © 2019 Gu Jun. All rights reserved.
//

import UIKit

class DDLyricalSong {
    var name = ""
}

class DDSongsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let CellIdentifier = "LyricalSongCellIdentifier"
    
    private let tableView = UITableView()
    private var songs = Array<DDMedia>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        tableView.separatorStyle = .none
        
        
        buildUI()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(DDSongItemTableViewCell.self, forCellReuseIdentifier: CellIdentifier)
        
//        loadSongs()
        load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadSongs()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as! DDSongItemTableViewCell
        cell.titleLabel.text = songs[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playerVC = DDPlayerViewController()
        playerVC.uuid = self.songs[indexPath.row].uuid
        self.navigationController?.pushViewController(playerVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    @objc func upload() {
        self.present(DDUploadViewController(), animated: true) {
            //
        }
    }
    
    @objc func showPlaying() {
        if DDLyricalPlayer.shared.nowPlayingUUID() != nil { self.navigationController?.pushViewController(DDPlayerViewController(), animated: true)
        }
    }
    
    private func buildUI() {
        let uploadButtonItem = UIBarButtonItem(title: "UPLOAD", style: .plain, target: self, action: #selector(upload))
        self.navigationItem.rightBarButtonItem = uploadButtonItem
        
        let nowPlayingButtonItem = UIBarButtonItem(title: "NOW", style: .plain, target: self, action: #selector(showPlaying))
        self.navigationItem.leftBarButtonItem = nowPlayingButtonItem
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func loadSongs() {
        loadSongs(false)
    }
    
    private func loadSongs(_ incremental: Bool) {
        var songs = Array<String>()
        let manager = FileManager.default
        let documentDirectory = manager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let contentsOfPath = try! manager.contentsOfDirectory(atPath: documentDirectory.path)
        for file in contentsOfPath {
            if (file.hasSuffix("mp3")) {
                songs.append(file)
            }
        }
        if incremental {
//            self.songs.append(contentsOf: songs)
        } else {
//            self.songs = songs
        }
    }
    
    private func load() {
        self.songs = DDLyricStore.shared.getAllMediaFiles()
    }
    
}
