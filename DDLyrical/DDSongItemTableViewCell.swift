//
//  DDSongItemTableViewCell.swift
//  DDLyrical
//
//  Created by Gu Jun on 2019/5/20.
//  Copyright © 2019 Gu Jun. All rights reserved.
//

import UIKit
import SnapKit

class DDSongItemTableViewCell: UITableViewCell {
    
    let separator = UIView()
    
    var titleLabel = UILabel()
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .clear
        self.selectionStyle = .none
        
        titleLabel.textColor = .darkGray
        titleLabel.font = .systemFont(ofSize: 20)
        contentView.addSubview(titleLabel)
        
        separator.backgroundColor = .init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        contentView.addSubview(separator)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
//            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(separator.snp_top)
            make.leftMargin.equalTo(10)
        }
        
        separator.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(10)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
