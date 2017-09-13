//
//  BundleLabelView.swift
//  LeJia
//
//  Created by 王嘉宁 on 2017/5/29.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import UIKit

/// 用 Frame 初始化
class BundleLabelView: UIView {

    // MARK: - Properties
    
    var data: [(String, String)] = [("","")] {
        didSet {
            
            leftLabel.titleLabel.text = ""
            leftLabel.subtitleLabel.text = ""
            centerLabel.titleLabel.text = ""
            centerLabel.subtitleLabel.text = ""
            rightLabel.titleLabel.text = ""
            rightLabel.subtitleLabel.text = ""
            
            let count = data.count
            
            guard count > 0 else { return }
            let (leftS, leftT) = data[0]
            leftLabel.titleLabel.text = leftT
            leftLabel.subtitleLabel.text = leftS
            
            guard count > 1 else { return }
            let (centerS, centerT) = data[1]
            centerLabel.titleLabel.text = centerT
            centerLabel.subtitleLabel.text = centerS
            
            guard count > 2 else { return }
            let (rightS, rightT) = data[2]
            rightLabel.titleLabel.text = rightT
            rightLabel.subtitleLabel.text = rightS
        }
    }
    
    var color: UIColor = .black {
        didSet {
            leftLabel.color = color
            centerLabel.color = color
            rightLabel.color = color
        }
    }
    
    var mainTitleFont: UIFont = UIFont() {
        didSet {
            leftLabel.titleLabel.font = mainTitleFont
            centerLabel.titleLabel.font = mainTitleFont
            rightLabel.titleLabel.font = mainTitleFont
        }
    }
    
    /** 设置渐变背景*/
    var setGradientBack = false {
        didSet {
            if setGradientBack {
                let topBlack = UIColor.customColor(red: 0, green: 0, blue: 0, alpha: 0)
                let centerBlack = UIColor.customColor(red: 0, green: 0, blue: 0, alpha: 0.4)
                let bottomBlack = UIColor.customColor(red: 0, green: 0, blue: 0, alpha: 0.8)
                self.applyGradient(colours: [topBlack, centerBlack, bottomBlack], locations: [0, 0.4, 1])
            }
        }
    }
    
    lazy var leftLabel: DoubleLabelView = {
        let l = DoubleLabelView(.vertical)
        l.alignment = .center
        return l
    }()
    
    lazy var centerLabel: DoubleLabelView = {
        let l = DoubleLabelView(.vertical)
        l.alignment = .center
        return l
    }()
    
    lazy var rightLabel: DoubleLabelView = {
        let l = DoubleLabelView(.vertical)
        l.alignment = .center
        return l
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        initUI()
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(frame: .zero)
    }
    
    func initUI() {
        [leftLabel, centerLabel, rightLabel].forEach {
            self.addSubview($0)
        }
        
        leftLabel.snp.makeConstraints { (make) in
            make.width.equalTo(70)
            make.height.equalTo(40)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        
        centerLabel.snp.makeConstraints { (make) in
            make.width.equalTo(70)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        rightLabel.snp.makeConstraints { (make) in
            make.width.equalTo(70)
            make.height.equalTo(40)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
    }

}




