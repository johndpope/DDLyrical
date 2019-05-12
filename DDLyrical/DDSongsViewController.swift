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
    private var songs = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        buildUI()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier)
        
//        loadSongs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadSongs()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath)
        cell.textLabel?.text = songs[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playerVC = DDPlayerViewController()
        playerVC.filename = self.songs[indexPath.row]
        self.navigationController?.pushViewController(playerVC, animated: true)
    }
    
    @objc func upload() {
        self.present(DDUploadViewController(), animated: true) {
            //
        }
    }
    
    private func buildUI() {
        let uploadButtonItem = UIBarButtonItem(title: "UPLOAD", style: .plain, target: self, action: #selector(upload))
        self.navigationItem.rightBarButtonItem = uploadButtonItem
        
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
            self.songs.append(contentsOf: songs)
        } else {
            self.songs = songs
        }
    }
}
