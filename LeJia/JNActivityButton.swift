//
//  JNActivityButton.swift
//  SecureLogon
//
//  Created by 王嘉宁 on 2017/4/13.
//  Copyright © 2017年 SDCA. All rights reserved.
//


import UIKit

public class JNActivityButton: JNButton {
    
    // MARK: - Properties
    
    /** 显示等待圈*/
    public var showActivity = true
    
    /** 是否是活动的*/
    public var isActive = false {
        didSet {
            if isActive {
                startActivityIndicator()
            } else {
                stopActivityIndicator()
            }
            isActive = !isActive
        }
    }
    
    /** 等待圈的偏移量, 默认为50*/
    public var indicatorOffset = 50 {
        didSet {
            initConstraints()
        }
    }
    
    /** 等待圈*/
    lazy var indicatorView: UIActivityIndicatorView = {
        let i = UIActivityIndicatorView(activityIndicatorStyle: .white)
        i.stopAnimating()
        i.hidesWhenStopped = true
        return i
    }()
    
    /** 等待时的黑色蒙版*/
    lazy var darkMask: UIView = { [unowned self] in
        let v = UIView()
        v.backgroundColor = .black
        v.alpha = 0.3
        v.layer.cornerRadius = self.radius
        v.isHidden = true
        return v
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
    
    func initUI() {
        [darkMask, indicatorView].forEach {
            addSubview($0)
        }
        initConstraints()
    }
    
    private func initConstraints() {
        indicatorView.snp.removeConstraints()
        indicatorView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(-indicatorOffset)
            make.centerY.equalToSuperview()
        }
        
        darkMask.snp.removeConstraints()
        darkMask.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    private func startActivityIndicator () {
        self.isEnabled = false
        darkMask.isHidden = false
        if showActivity {
            indicatorView.startAnimating()
        }
    }
    
    private func stopActivityIndicator () {
        self.isEnabled = true
        darkMask.isHidden = true
        if showActivity {
            indicatorView.stopAnimating()
        }
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

