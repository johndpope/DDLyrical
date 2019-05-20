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
        annotationWrapper.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(24)
        }
        segmentsWrapper.snp.makeConstraints { (make) in
            make.top.equalTo(annotationWrapper.snp_bottom)
//            make.centerX.equalToSuperview()
//            make.topMargin.equalTo(50)
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.height.equalTo(24)
        }
        translationView.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.top.equalTo(segmentsWrapper.snp_bottom)
        }
    }
    
    func buildAnnotations() {
        for item in segmentsWrapper.subviews {
            item.removeFromSuperview()
        }
        
        var labelArray = Array<UILabel>()
        for item in segments {
            let label = UILabel()
            label.text = item
            label.frame = label.text!.boundingRect(with: CGSize.init(), options: .usesFontLeading, attributes: nil, context: nil)
            labelArray.append(label)
        }
        let subStackView = UIStackView(arrangedSubviews: labelArray)
        subStackView.axis = .horizontal
        subStackView.distribution = .fill
        subStackView.alignment = .fill
        subStackView.spacing = 5
        
        
        segmentsWrapper.addSubview(subStackView)

        subStackView.snp.makeConstraints { (make) in
            make.height.equalTo(24)
            make.center.equalToSuperview()
        }
        
        layoutIfNeeded()
        
        
        for item in annotationWrapper.subviews {
            item.removeFromSuperview()
        }
        
        for item in annotations {
            let label = UILabel()
            label.lineBreakMode = .byClipping
            label.clipsToBounds = false
            label.layer.masksToBounds = false
            label.text = item.furigana
            label.adjustsFontSizeToFitWidth = true
            let size = label.text!.boundingRect(with: CGSize.init(), options: .usesFontLeading, attributes: nil, context: nil)
            var frameX = subStackView.subviews[0..<item.segmentIndex].reduce(0.0) { (x, view) -> CGFloat in
                x + view.frame.size.width
            }
            frameX += subStackView.frame.origin.x + CGFloat(item.segmentIndex) * subStackView.spacing
            label.frame = CGRect(x: frameX, y: 0, width: size.width, height: 24)
//            print(label.convert(label.bounds, to: nil))
//            label.backgroundColor = .blue
            annotationWrapper.addSubview(label)
        }
        setNeedsDisplay()
    }
    
}
