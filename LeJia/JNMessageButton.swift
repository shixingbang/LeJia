//
//  JNMessageButton.swift
//  SecureLogon
//
//  Created by 王嘉宁 on 2017/4/13.
//  Copyright © 2017年 SDCA. All rights reserved.
//

import UIKit

public class JNMessageButton: JNButton {
    
    // MARK: - Properties
    
    /** 主要颜色*/
    override public var color: UIColor {
        didSet {
            self.backgroundColor = color
            self.dispalyLabel.backgroundColor = color
        }
    }
    
    /** 是否是活动的*/
    public var isActive = false {
        didSet {
            if isActive {
                startTimer()
            } else {
                stopTimer()
            }
            isActive = !isActive
        }
    }
    
    /** 等待时间, 默认60秒*/
    public var time = 60
    
    /** 活动状态时显示的label*/
    public var dispalyLabel: UILabel!
    
    /** 计时器*/
    private var timer: Timer?
    private var counter = 0
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        initUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    deinit {
        stopTimer()
    }
    
    
    func initUI() {
        
        dispalyLabel = UILabel(frame: CGRect(x: 1, y: 1, width: 78, height: 28))
        dispalyLabel.layer.masksToBounds = true
        dispalyLabel.layer.cornerRadius = 28 / 2
        dispalyLabel.font = UIFont.defaultFont(size: 11)
        dispalyLabel.textAlignment = .center
        normalMode()
        addSubview(dispalyLabel)
    }
    
    private func startTimer() {
        disabledMode()
        guard timer == nil else {
            return
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(JNMessageButton.updateTimer), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        normalMode()
        timer?.invalidate()
        counter = 0
    }
    
    func updateTimer() {
        guard time - counter > 0 else {
            stopTimer()
            return
        }
        counter += 1
        dispalyLabel.text = "剩余\(time - counter)秒"
    }
    
    /** 正常模式*/
    private func normalMode() {
        dispalyLabel.textColor = .white
        dispalyLabel.backgroundColor = color
        dispalyLabel.text = "短信验证码"
        self.isEnabled = true
    }
    
    /** 活动模式*/
    private func disabledMode() {
        dispalyLabel.textColor = color
        dispalyLabel.backgroundColor = .white
        dispalyLabel.text = "剩余\(time)秒"
        self.isEnabled = false
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
