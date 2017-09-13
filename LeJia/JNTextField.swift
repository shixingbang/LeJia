//
//  JNTextField.swift
//  SecureLogon
//
//  Created by 王嘉宁 on 2017/4/13.
//  Copyright © 2017年 SDCA. All rights reserved.
//

import UIKit
import SnapKit

public class JNTextField: UITextField {
    
    public var icon: UIImage = UIImage() {
        didSet {
            setLeftImageView(image: icon)
        }
    }
    
    private var dividingLine: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        v.alpha = 0.2
        return v
    }()
    
    init() {
        super.init(frame: .zero)
        
        [dividingLine].forEach {
            addSubview($0)
        }
        
        dividingLine.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.bottom.equalToSuperview().offset(-1)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview()
        }
        
        self.clearButtonMode = .whileEditing
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setLeftImageView(image: UIImage) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.image = image
        imageView.contentMode = .center
        self.leftView = imageView
        self.leftViewMode = .always
    }
}

