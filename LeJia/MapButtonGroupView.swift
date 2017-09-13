//
//  MapButtonGroupView.swift
//  LeJia
//
//  Created by 王嘉宁 on 2017/5/14.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import UIKit

class MapButtonGroupView: UIView {
    
    // MARK: - Properties
    
    lazy var separatorLine: UIView = {
        let v = UIView()
        v.backgroundColor = LJ.grayLine
        return v
    }()
    
    lazy var locationButton: UIButton = { [unowned self] in
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "main_btn_location"), for: .normal)
        return b
    }()
    
    lazy var naviButton: UIButton = { [unowned self] in
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "main_btn_navi"), for: .normal)
        return b
    }()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = LJ.whiteYellow
        self.layer.cornerRadius = 10
        
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 1
        
        [separatorLine, locationButton,
         naviButton].forEach {
            self.addSubview($0)
        }
        
        separatorLine.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        locationButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(45)
            make.left.top.equalToSuperview()
        }
        
        naviButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(45)
            make.left.bottom.equalToSuperview()
        }
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }

}
