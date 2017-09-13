//
//  SearchIconCollectionViewCell.swift
//  LeJia
//
//  Created by 王嘉宁 on 2017/5/16.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import UIKit

class SearchIconCollectionViewCell: UICollectionViewCell {
    
    var fontSize: CGFloat = 13
    
    var title: String = "" {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    var image: UIImage = UIImage() {
        didSet {
            self.iconImageView.image = image
        }
    }
    
    lazy var iconImageView: UIImageView = {
        let i = UIImageView()
        return i
    }()
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: CGFloat(self.fontSize))
        l.text = self.title
        l.textAlignment = .center
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(frame: .zero)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initUI() {
        
        [iconImageView, titleLabel].forEach {
            addSubview($0)
        }
        
        iconImageView.snp.makeConstraints { (make) in
            make.width.equalTo(60)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconImageView).offset(60)
            make.height.equalTo(20)
            make.left.right.equalToSuperview()
        }
    }
    
}
