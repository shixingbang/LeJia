//
//  MapSearchBarView.swift
//  LeJia
//
//  Created by 王嘉宁 on 2017/5/14.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import UIKit

class MapSearchBarView: UIView {
    
    // MARK: - Properties
    
    var isOnMap: Bool
    
    lazy var textBackView: UIView = {
        let v = UIView()
        v.backgroundColor = LJ.grayLightSearch
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 10
        return v
    }()
    
    lazy var menuButton: UIButton = { [unowned self] in
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "main_btn_menu"), for: .normal)
        return b
        }()
    
    lazy var searchTextField: UITextField = {
        let t = UITextField()
        t.borderStyle = .none
        t.textColor = LJ.grayLightSearchFont
        t.attributedPlaceholder = NSAttributedString(string: "搜索地图",
                                                     attributes: [NSForegroundColorAttributeName: LJ.grayLightSearchFont])
        t.clearButtonMode = .whileEditing
        return t
    }()
    
    lazy var showSearchButton: UIButton = { [unowned self] in
        let b = UIButton()
        return b
        }()
    
    lazy var backButton: UIButton = { [unowned self] in
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "search_btn_back"), for: .normal)
        return b
        }()
    
    // MARK: - Init
    
    init(isOnMap: Bool) {
        self.isOnMap = isOnMap
        super.init(frame: .zero)
        
        self.backgroundColor = LJ.whiteYellow
        self.layer.cornerRadius = 10
        
        [textBackView, searchTextField].forEach {
            self.addSubview($0)
        }
        
        textBackView.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
        
        
        
        searchTextField.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.left.equalToSuperview().offset(60)
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
        
        if self.isOnMap {
            // 阴影突出
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.layer.shadowOpacity = 0.3
            self.layer.shadowRadius = 1
            
            self.addSubview(menuButton)
            menuButton.snp.makeConstraints { (make) in
                make.width.height.equalTo(40)
                make.left.equalToSuperview().offset(10)
                make.top.equalToSuperview().offset(10)
            }
            
            self.addSubview(showSearchButton)
            showSearchButton.snp.makeConstraints { (make) in
                make.height.equalTo(40)
                make.left.equalToSuperview().offset(60)
                make.right.equalToSuperview().offset(-10)
                make.centerY.equalToSuperview()
            }
            
        } else {
            
            self.layer.masksToBounds = true
            
            self.addSubview(backButton)
            backButton.snp.makeConstraints { (make) in
                make.width.height.equalTo(40)
                make.left.equalToSuperview().offset(10)
                make.top.equalToSuperview().offset(10)
            }
            
        }
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(isOnMap: false)
    }
    
}
