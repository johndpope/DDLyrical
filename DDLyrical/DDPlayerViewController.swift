//
//  DDPlayerViewController.swift
//  DDLyrical
//
//  Created by Gu Jun on 2019/4/21.
//  Copyright © 2019 Gu Jun. All rights reserved.
//

import UIKit

class DDPlayerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let CellIdentifier = "LyricLineCellIdentifier"
    
    let tableView = UITableView()
    
    var lines = Array<DDLyricLine>()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        tableView.backgroundColor = .red
        tableView.frame = UIScreen.main.bounds
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        mockdata()
        
        tableView.register(DDLyricTableViewCell.self, forCellReuseIdentifier: CellIdentifier)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as! DDLyricTableViewCell
        let line = lines[indexPath.row]
        let label = UILabel()
        label.text = line.original
        cell.originalView.addSubview(label)
        return cell
    }

    private func mockdata() {
        var array = Array<DDLyricLine>()
        let line = DDLyricLine()
        line.original = "どこかで鐘が鳴って"
        line.translation = "不知何处的钟声响起"
        array.append(line)
        self.lines = array
    }
}
