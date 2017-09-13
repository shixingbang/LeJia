//
//  JNTextField.swift
//  SecureLogon
//
//  Created by 王嘉宁 on 2017/4/13.
//  Copyright © 2017年 SDCA. All rights reserved.
//

import UIKit
import SnapKit

public class JNIconTextField: UITextField {
    
    // MARK: - Properties
    
    /** 设置图标*/
    public var icon: UIImage = UIImage() {
        didSet {
            setLeftImageView(image: icon)
        }
    }
    
    /** 设置占位符颜色*/
    public var placeholderColor: UIColor = .black {
        didSet {
            guard let placeholder = placeholder else { return }
            attributedPlaceholder =
                NSAttributedString(string: placeholder,
                                   attributes: [NSForegroundColorAttributeName:
                                    placeholderColor])
        }
    }
    
    /** 设置分割线颜色*/
    public var separatorColor: UIColor = .black {
        didSet {
            self.separator.backgroundColor = separatorColor
        }
    }
    
    /** 分割线*/
    private var separator: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        v.alpha = 0.2
        return v
    }()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        initUI()
    }
    
    /**
     初始化
     - parameter icon: 左侧图标
     */
    init(icon: UIImage) {
        super.init(frame: .zero)
        initUI()
        self.setLeftImageView(image: icon)
    }
    
    func initUI() {
        self.clearButtonMode = .whileEditing
        
        [separator].forEach {
            addSubview($0)
        }
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        separator.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview().offset(-0.5)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview()
        }
    }
    
    // MARK: - Action
    
    /** 设置左侧图片*/
    private func setLeftImageView(image: UIImage) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.image = image
        imageView.contentMode = .center
        self.leftView = imageView
        self.leftViewMode = .always
    }
}

