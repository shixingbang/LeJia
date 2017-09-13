//
//  JNSelectButton.swift
//  LeJia
//
//  Created by 王嘉宁 on 2017/5/30.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import Foundation

public class JNSelectButton: UIButton {
    
    // MARK: - Properties

    /** 颜色*/
    public var color: UIColor = .black {
        didSet {
            setTitleColor(color, for: .normal)
            setTitleColor(.white, for: .selected)
            self.layer.borderColor = color.cgColor
        }
    }
    
    public override var isSelected: Bool {
        didSet {
            if isSelected {
                self.backgroundColor = color
            } else {
                self.backgroundColor = .white
            }
        }
    }
    
    /** 圆角*/
    public var radius: CGFloat = 4 {
        didSet {
            layer.cornerRadius = radius
        }
    }
    
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
        layer.cornerRadius = radius
        layer.borderWidth = 1
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
