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
    
//    lazy var lyric = DDLyricLine()
    
    var annotationWrapper = UIView()
    var segmentsWrapper = UIView()
    var translationView = UILabel()
    
    var segments = Array<String>()
    var annotations = Array<DDLyricAnnotation>()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        translationView.textAlignment = .center
        
        contentView.addSubview(annotationWrapper)
        contentView.addSubview(segmentsWrapper)
        contentView.addSubview(translationView)
        
        buildSubviewContraints()
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func buildSubviewContraints() {
//        annotationWrapper.backgroundColor = .red
        annotationWrapper.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(24)
        }
        segmentsWrapper.snp.makeConstraints { (make) in
            make.top.equalTo(annotationWrapper.snp_bottom)
            make.centerX.equalToSuperview()
//            make.topMargin.equalTo(50)
//            make.leading.equalTo(contentView)
//            make.trailing.equalTo(contentView)
        }
        translationView.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.top.equalTo(segmentsWrapper.snp_bottom)
        }
    }
    
    func buildAnnotations() {
        for item in segments {
            let label = UILabel()
            label.text = item
            segmentsWrapper.addSubview(label)
        }
        
        for item in annotations {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
            label.text = item.furigana
            let size = UIScreen.main.bounds.size
            
            let dic = Dictionary<String, Any>()
//            print((label.text! as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedString.Key : Any], context: nil))
            annotationWrapper.addSubview(label)
        }
        setNeedsDisplay()
    }
    
}
