//
//  ServiceCell.swift
//  LeJia
//
//  Created by 王嘉宁 on 2017/5/31.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import Foundation

class ServiceCell: UIView {
    
    // MARK: - Properties
    
    var radius: CGFloat = 5
    
    var image: UIImage = UIImage() {
        didSet {
            self.serviceImageView.image = image
        }
    }
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var subtitle: String = "" {
        didSet {
            subtitleLabel.text = subtitle
        }
    }
    
    lazy var serviceImageView: UIImageView = {
        let i = UIImageView()
        i.layer.masksToBounds = true
        i.layer.cornerRadius = self.radius
        i.layer.borderWidth = 0.5
        i.layer.borderColor = UIColor.gray.cgColor
        return i
    }()
    
    lazy var darkMaskView: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        v.alpha = 0.3
        return v
    }()
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Title"
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = .black
        return l
    }()
    
    lazy var subtitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Subitle"
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = .black
        l.alpha = 0.5
        return l
    }()
    
    // MARK: - Init
    
    init(imageSize: CGSize) {
        super.init(frame: .zero)
        
        [serviceImageView, titleLabel, subtitleLabel].forEach {
            self.addSubview($0)
        }
        
        serviceImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(1)
            make.size.equalTo(imageSize)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(LJ.controlsHeight / 2)
            make.bottom.equalTo(serviceImageView).offset(LJ.controlsHeight / 2 + 5)
        }
        
        subtitleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(LJ.controlsHeight / 2)
            make.bottom.equalTo(titleLabel).offset(LJ.controlsHeight / 2)
        }
        
        
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(imageSize: CGSize(width: 335, height: 200))
    }
    
}
