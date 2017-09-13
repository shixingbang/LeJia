//
//  BundleLabelButtonView.swift
//  LeJia
//
//  Created by 王嘉宁 on 2017/5/30.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import Foundation

enum BundleButtonSelectedIndex: Int {
    case none = -1
    case left = 0
    case center = 1
    case right = 2
}

protocol BundleButtonSelectedChangeDelegate {
    func buttonSelectedChange(_ selectedIndex: BundleButtonSelectedIndex)
}

class BundleLabelButtonView: BundleLabelView {
    
    // MARK: - Properties
    
    var delegate: BundleButtonSelectedChangeDelegate?
    
    var buttonSelectedIndex: BundleButtonSelectedIndex = .none {
        didSet {
            delegate?.buttonSelectedChange(buttonSelectedIndex)
        }
    }
    
    lazy var leftButton: JNSelectButton = { [unowned self] in
        let b = JNSelectButton()
        b.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        b.setTitle("选择", for: .normal)
        b.setTitle("已选", for: .selected)
        b.addTarget(self, action: .left, for: .touchUpInside)
        return b
    }()
    
    lazy var centerButton: JNSelectButton = { [unowned self] in
        let b = JNSelectButton()
        b.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        b.setTitle("选择", for: .normal)
        b.setTitle("已选", for: .selected)
        b.addTarget(self, action: .center, for: .touchUpInside)
        return b
    }()
    
    lazy var rightButton: JNSelectButton = { [unowned self] in
        let b = JNSelectButton()
        b.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        b.setTitle("选择", for: .normal)
        b.setTitle("已选", for: .selected)
        b.addTarget(self, action: .right, for: .touchUpInside)
        return b
    }()
    
    override var data: [(String, String)] {
        didSet {
            
            leftLabel.titleLabel.text = ""
            leftLabel.subtitleLabel.text = ""
            centerLabel.titleLabel.text = ""
            centerLabel.subtitleLabel.text = ""
            rightLabel.titleLabel.text = ""
            rightLabel.subtitleLabel.text = ""
            
            leftButton.isHidden = true
            centerButton.isHidden = true
            rightButton.isHidden = true
            
            let count = data.count
            
            guard count > 0 else { return }
            let (leftS, leftT) = data[0]
            leftLabel.titleLabel.text = leftT
            leftLabel.subtitleLabel.text = leftS
            leftButton.isHidden = false
            
            guard count > 1 else { return }
            let (centerS, centerT) = data[1]
            centerLabel.titleLabel.text = centerT
            centerLabel.subtitleLabel.text = centerS
            centerButton.isHidden = false
            
            guard count > 2 else { return }
            let (rightS, rightT) = data[2]
            rightLabel.titleLabel.text = rightT
            rightLabel.subtitleLabel.text = rightS
            rightButton.isHidden = false
        }
    }
    
    var buttonColor: UIColor = .black {
        didSet {
            leftButton.color = buttonColor
            centerButton.color = buttonColor
            rightButton.color = buttonColor
            
            leftButton.isSelected = false
            centerButton.isSelected = false
            rightButton.isSelected = false
        }
    }
    
    // MARK: - Init
    
    override func initUI() {
        [leftLabel, centerLabel, rightLabel,
         leftButton, centerButton, rightButton].forEach {
            self.addSubview($0)
        }
        
        leftLabel.snp.makeConstraints { (make) in
            make.width.equalTo(70)
            make.height.equalTo(LJ.controlsHeight)
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        
        leftButton.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.height.equalTo(30)
            make.top.equalTo(leftLabel).offset(LJ.controlsHeight + 5)
            make.centerX.equalTo(leftLabel)
        }
        
        centerLabel.snp.makeConstraints { (make) in
            make.width.equalTo(70)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        centerButton.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.height.equalTo(30)
            make.top.equalTo(centerLabel).offset(LJ.controlsHeight + 5)
            make.centerX.equalTo(centerLabel)
        }
        
        rightLabel.snp.makeConstraints { (make) in
            make.width.equalTo(70)
            make.height.equalTo(40)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview()
        }
        
        rightButton.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.height.equalTo(30)
            make.top.equalTo(rightLabel).offset(LJ.controlsHeight + 5)
            make.centerX.equalTo(rightLabel)
        }
    }
    
    // MARK: - Button Action
    
    private func setAllUnseleted() {
        leftButton.isSelected = false
        centerButton.isSelected = false
        rightButton.isSelected = false
        buttonSelectedIndex = .none
    }
    
    func leftButtonTapped() {
        setAllUnseleted()
        leftButton.isSelected = true
        buttonSelectedIndex = .left
    }
    
    func centerButtonTapped() {
        setAllUnseleted()
        centerButton.isSelected = true
        buttonSelectedIndex = .center
    }
    
    func rightButtonTapped() {
        setAllUnseleted()
        rightButton.isSelected = true
        buttonSelectedIndex = .right
    }
}

fileprivate extension Selector {
    static let left = #selector(BundleLabelButtonView.leftButtonTapped)
    static let center = #selector(BundleLabelButtonView.centerButtonTapped)
    static let right = #selector(BundleLabelButtonView.rightButtonTapped)
}






