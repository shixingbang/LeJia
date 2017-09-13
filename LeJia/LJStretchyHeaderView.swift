//
//  LJStretchyHeaderView.swift
//  LeJia
//
//  Created by 王嘉宁 on 2017/5/29.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import UIKit
import GSKStretchyHeaderView

class LJStretchyHeaderView: GSKStretchyHeaderView {
    
    // MARK: - Properties
    
    var title = "" {
        didSet {
            self.titleLabel.text = title
            self.navigationTitleLabel.text = title
        }
    }
    
    var subtitle = "" {
        didSet {
            self.subtitleLabel.text = subtitle
        }
    }
    
    var backImage = UIImage() {
        didSet {
            self.backImageView.image = backImage
        }
    }
    
    lazy var backImageView: UIImageView = {
        let i = UIImageView(frame: self.contentView.bounds)
        i.contentMode = .scaleAspectFill
        return i
    }()
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Stretchy Header View Title"
        l.font = UIFont.systemFont(ofSize: 30)
        l.textColor = .white
        return l
    }()
    
    lazy var subtitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Stretchy Header View Subitle"
        l.font = UIFont.systemFont(ofSize: 12)
        l.textColor = .white
        l.alpha = 0.5
        return l
    }()
    
    lazy var navigationTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Stretchy Header View Title"
        l.font = UIFont.systemFont(ofSize: 17)
        l.textColor = .white
        l.textAlignment = .center
        return l
    }()

    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        initUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    func initUI() {
        
        self.expansionMode = GSKStretchyHeaderViewExpansionMode.immediate
        
        self.minimumContentHeight = LJ.navigationBarHeight
        self.maximumContentHeight = self.frame.height + 30
        
        [backImageView, titleLabel,
         subtitleLabel, navigationTitleLabel].forEach {
            self.contentView.addSubview($0)
        }
        
        backImageView.snp.makeConstraints { (make) in
            make.left.bottom.right.top.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview()
            make.height.equalTo(LJ.controlsHeight + 10)
            make.centerY.equalToSuperview()
        }
        
        navigationTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(LJ.controlsHeight)
            make.centerY.equalToSuperview().offset(10)
        }
        
        subtitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview()
            make.height.equalTo(LJ.controlsHeight)
            make.top.equalTo(titleLabel).offset(LJ.controlsMargin)
        }
        
    }
    
    override func didChangeStretchFactor(_ stretchFactor: CGFloat) {
        super.didChangeStretchFactor(stretchFactor)
        
        var alpha = CGFloatTranslateRange(stretchFactor, 0.2, 0.8, 0, 1)
        alpha = max(0, min(1, alpha))
        
        self.titleLabel.alpha = alpha
        self.subtitleLabel.alpha = max(0, alpha - 0.4)
        
        self.backImageView.alpha = alpha
        
        let navTitleFactor: CGFloat = 0.4
        var navTitleAlpha: CGFloat = 0
        
        if stretchFactor < navTitleFactor {
            navTitleAlpha = CGFloatTranslateRange(stretchFactor, 0, navTitleFactor, 1, 0)
        }
        
        self.navigationTitleLabel.alpha = navTitleAlpha
    }
}





