//
//  DDLyricTableViewCell.swift
//  DDLyrical
//
//  Created by Gu Jun on 2019/4/21.
//  Copyright © 2019 Gu Jun. All rights reserved.
//

import UIKit
import SnapKit

class DDLyricTableViewCell: UITableViewCell {
    
    lazy var lyric = DDLyricLine()
    
    var originalView = UIView()
    var translationView = UIView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        originalView.backgroundColor = .blue
        contentView.addSubview(originalView)
        contentView.addSubview(translationView)
        
        setSubviewContraints()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setSubviewContraints() {
        originalView.snp.makeConstraints { (make) in
            make.width.height.equalTo(50)
            make.center.equalTo(contentView)
        }
    }
}
