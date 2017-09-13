//
//  NewsCell.swift
//  LeJia
//
//  Created by 王嘉宁 on 2017/5/31.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import Foundation

class NewsCell: UIView {
    
    // MARK: - Properties
    
    var radius: CGFloat = 8
    
    var image: UIImage = UIImage() {
        didSet {
            self.newsImageView.image = image
        }
    }
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    lazy var newsShadowImageView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = self.radius
        v.layer.shadowRadius = 3
        v.layer.shadowOffset = CGSize(width: 0, height: 0)
        v.layer.shadowOpacity = 0.8
        return v
    }()
    
    lazy var newsImageView: UIImageView = {
        let i = UIImageView()
        i.layer.masksToBounds = true
        i.layer.cornerRadius = 8
        i.layer.shadowRadius = 2
        i.layer.shadowOffset = CGSize(width: 0, height: 0)
        i.layer.shadowOpacity = 0.3
        return i
    }()
    
    lazy var darkMaskView: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 8
        v.alpha = 0.2
        return v
    }()
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Title"
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = .white
        l.textAlignment = .center
        return l
    }()
    
    // MARK: - Init
    
    init(imageSize: CGSize) {
        super.init(frame: .zero)
        
        self.backgroundColor = .white
        
        [newsShadowImageView, darkMaskView, titleLabel].forEach {
            self.addSubview($0)
        }
        
        newsShadowImageView.addSubview(newsImageView)
        
        newsShadowImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(imageSize)
        }
        
        newsImageView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        darkMaskView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(newsImageView)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(LJ.controlsHeight - 10)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(imageSize: CGSize(width: 335, height: 200))
    }

}


