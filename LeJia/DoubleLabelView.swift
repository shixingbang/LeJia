//
//  DoubleLabelView.swift
//  LeJia
//
//  Created by 王嘉宁 on 2017/5/29.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import UIKit

enum DoubleLabelViewAxis {
    case horizontal
    case vertical
}

class DoubleLabelView: UIView {

    // MARK: - Properties
    
    var data: (String, String) = ("", "") {
        didSet {
            let (subtitle, title) = data
            self.titleLabel.text = title
            self.subtitleLabel.text = subtitle
        }
    }
    
    var alignment: NSTextAlignment = .left {
        didSet {
            titleLabel.textAlignment = alignment
            subtitleLabel.textAlignment = alignment
        }
    }
    
    var color: UIColor = .black {
        didSet {
            titleLabel.textColor = color
            subtitleLabel.textColor = color
        }
    }
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Title"
        l.font = UIFont.systemFont(ofSize: 12)
        l.textColor = .black
        return l
    }()
    
    lazy var subtitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Subitle"
        l.font = UIFont.systemFont(ofSize: 12)
        l.textColor = .black
        l.alpha = 0.5
        return l
    }()

    // MARK: - Init
    
    init(_ axis: DoubleLabelViewAxis, leftLabelWidth: Int = 50, labelHeight: Int = 20, subLabelHeight: Int = 20, distance: Int = 10) {
        super.init(frame: .zero)
        
        [titleLabel, subtitleLabel].forEach {
            self.addSubview($0)
        }
        
        switch axis {
        case .horizontal:
            subtitleLabel.snp.makeConstraints { (make) in
                make.width.equalTo(leftLabelWidth)
                make.left.bottom.top.equalToSuperview()
            }
            
            titleLabel.snp.makeConstraints { (make) in
                make.left.equalTo(subtitleLabel).offset(leftLabelWidth + distance)
                make.top.right.bottom.equalToSuperview()
            }
        case .vertical:
            subtitleLabel.snp.makeConstraints { (make) in
                make.height.equalTo(subLabelHeight)
                make.left.right.top.equalToSuperview()
            }
            
            titleLabel.snp.makeConstraints { (make) in
                make.height.equalTo(labelHeight)
                make.left.right.bottom.equalToSuperview()
            }
        }
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(.horizontal)
    }
    
}
