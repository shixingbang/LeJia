//
//  LeftProfileView.swift
//  LeJia
//
//  Created by 王嘉宁 on 2017/5/14.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import UIKit
import Kingfisher

class LeftProfileView: UIView {
    
    // MARK: - Properties
    
    var avatarWidth: CGFloat = 60
    var avatarURL: String = "" {
        didSet {
            self.avatarImageView.kf.setImage(with: ImageResource.init(downloadURL: URL(string: avatarURL)!), placeholder: #imageLiteral(resourceName: "test_avatar2"), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    
    var avatar: UIImage = UIImage() {
        didSet {
            self.avatarImageView.image = avatar
        }
    }
    
    var userRealName: String = "" {
        didSet {
            self.userRealNameLabel.text = userRealName
        }
    }
    
    lazy var avatarImageView: UIImageView = {
        let i = UIImageView()
        i.layer.masksToBounds = true
        i.layer.cornerRadius = self.avatarWidth / 2
        i.image = #imageLiteral(resourceName: "left_icon_defaultAvatar")
        return i
    }()
    
    lazy var userRealNameLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 20)
        l.textColor = .white
        l.text = "未登录"
        return l
    }()
    
    lazy var separatorLine: UIImageView = {
        let i = UIImageView()
        i.image = #imageLiteral(resourceName: "left_line")
        return i
    }()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        [avatarImageView, userRealNameLabel,
         separatorLine].forEach {
            self.addSubview($0)
        }
        
        avatarImageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(avatarWidth)
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(LJ.controlsMargin - 20)
        }
        
        userRealNameLabel.snp.makeConstraints { (make) in
            make.height.equalTo(60)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(avatarImageView).offset(60)
        }
        
        separatorLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    
}
