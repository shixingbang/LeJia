//
//  JNNormalTableViewCell.swift
//  SecureLogon
//
//  Created by 王嘉宁 on 2017/4/13.
//  Copyright © 2017年 SDCA. All rights reserved.
//

import UIKit
import SnapKit

class JNNormalTableViewCell: UITableViewCell {
    
    var imageViewWidth: Int = 40
    var labelFontSize: Int = 40
    
    lazy var iconImageView: UIImageView = {
        let i = UIImageView()
        i.contentMode = .center
        return i
    }()
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 20)
        return l
    }()

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        [iconImageView, titleLabel].forEach {
            addSubview($0)
        }
        
        iconImageView.snp.makeConstraints { (make) in
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(70)
            make.right.equalToSuperview().offset(-10)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
