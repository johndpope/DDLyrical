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
    private var songs = Array<DDLyricalSong>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        loadSongs()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath)
        cell.textLabel?.text = songs[indexPath.row].name
        return cell
    }
    
    private func loadSongs() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    }
}
