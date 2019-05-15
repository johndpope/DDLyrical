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
//        testUTF8()
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
    
    private func testUTF8() {
//        let strToDecode = "🐶"
//        let strToDecode = "い"
        let strToDecode = "中"
        let str = strToDecode.utf8DecodedString()
        print(str)
//        for codeUnit in strToDecode.utf8 {
//            print(codeUnit)
//            print(String().appendingFormat("%x", codeUnit))
//        }

        for scalar in strToDecode.unicodeScalars {
            print(scalar.value)
            print(String().appendingFormat("%x", scalar.value))
        }
        
//        print("\u{3044}")
        print(validateEmail(str: "🐶"))
        print(validateEmail(str: "い"))
        print(validateEmail(str: strToDecode))
    }
    
    private func validateEmail(str: String) -> Bool {
        // 1.编写邮箱规则(来自Internet)
//        let pattern = "^[A-Za-zd]+([-_.][A-Za-zd]+)*@([A-Za-zd]+[-.])+[A-Za-zd]{2,5}$"
        let pattern = "^[\\u3040-\\u309F]+$"
        
        // 2.根据规则创建正则表达式对象
        guard let regex = try? NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options(rawValue: 0)) else {
            return false
        }
        
        // 3.根据对象匹配数据
        // range: 检验传入字符串str的哪些部分,此处为全部
        let result: Int = regex.numberOfMatches(in: str,
                                                        options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                                        range: NSMakeRange(0, str.count))
        return result > 0
        
    }
}

extension String {
    
    func utf8DecodedString()-> String {
        let data = self.data(using: .unicode)
        if let message = String(data: data!, encoding: .unicode){
            return message
        }
        return ""
    }
}
