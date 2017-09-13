//
//  JNButton.swift
//  SecureLogon
//
//  Created by 王嘉宁 on 2017/4/13.
//  Copyright © 2017年 SDCA. All rights reserved.
//

import Foundation
import UIKit

public class JNButton: UIButton {
    
    // MARK: - Properties
    
    /** 背景颜色*/
    public var color: UIColor = .white {
        didSet {
            self.backgroundColor = color
        }
    }
    
    /** 标题*/
    public var title: String = "" {
        didSet {
            setTitle(title, for: .normal)
        }
    }
    
    /** 设置左侧图标, 并偏移*/
    public var icon: UIImage = UIImage() {
        didSet {
            setImage(icon, for: .normal)
            let offset = icon.size.width
            titleEdgeInsets = UIEdgeInsetsMake(0, -offset, 0, 0)
        }
    }
    
    /** 圆角*/
    public var radius: CGFloat = 3 {
        didSet {
            layer.cornerRadius = radius
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        tintColor = .white
        layer.masksToBounds = true
        layer.cornerRadius = radius
        imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 50)
        
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
