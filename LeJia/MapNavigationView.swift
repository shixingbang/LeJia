//
//  MapNavigationView.swift
//  LeJia
//
//  Created by 王嘉宁 on 2017/5/22.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import UIKit

class MapNavigationView: UIView {

    // MARK: - Properties
    
    /* // 是否可点击
    var isEnabled = false {
        didSet {
            if !isEnabled {
                self.naviButton.isEnabled = false
                self.naviButton.backgroundColor = LJ.grayLightSearch
            } else {
                self.naviButton.isEnabled = true
                self.naviButton.backgroundColor = LJ.blueDefault
            }
        }
    }
    */
    
    var placeName = "" {
        didSet {
            self.placeNameLabel.text = placeName
        }
    }
    
    var placeLocation = "" {
        didSet {
            self.placeLocationLabel.text = placeLocation
        }
    }
    
    lazy var placeNameLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightMedium)
        return l
    }()
    
    lazy var placeLocationLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 14)
        return l
    }()
    
    lazy var naviLabel: UILabel = {
        let l = UILabel()
        l.text = "开始导航"
        l.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
        l.textColor = .white
        l.textAlignment = .center
        return l
    }()
    
    lazy var timeLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = .white
        l.textAlignment = .center
        return l
    }()
    
    lazy var closeButton: UIButton = { [unowned self] in
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "navi_btn_close"), for: .normal)
        return b
    }()
    
    lazy var naviButton: UIButton = { [unowned self] in
        let b = UIButton()
        b.backgroundColor = LJ.blueDefault
        b.layer.masksToBounds = true
        b.layer.cornerRadius = 8
        return b
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = LJ.whiteYellow
        self.layer.cornerRadius = 10
        
        [placeNameLabel, placeLocationLabel,
         closeButton, naviButton].forEach {
            self.addSubview($0)
        }
        
        placeNameLabel.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(20)
        }
        
        placeLocationLabel.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(placeNameLabel).offset(35)
        }
        
        closeButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(25)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(20)
        }
        
        naviButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(placeLocationLabel).offset(20 + 15)
        }
        
        [naviLabel, timeLabel].forEach {
            naviButton.addSubview($0)
        }
        
        naviLabel.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(5)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(naviLabel).offset(20)
        }

    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init(frame: .zero)
    }
    
    // MARK: - Action
    
    func clearText() {
        [placeNameLabel, placeLocationLabel,
         timeLabel].forEach {
            $0.text = ""
        }
        placeName = ""
        placeLocation = ""
    }
    
    func setTimeDistanceText(time: Int, distance: Double) {
        
        // 时间转换
        let timeTmp = time
        let hour = timeTmp / 3600
        let min = (timeTmp - hour * 3600) / 60
        var timeText = ""
        if hour > 0 {
            timeText += "\(hour)小时"
        }
        if min > 0 {
            timeText += "\(min)分钟"
        }
        timeLabel.text = timeText
        
        // 距离转换
        let distanceTmp = distance
        var distanceText = ""
        if distanceTmp > 1000 {
            let km = distanceTmp / 1000
            distanceText = String(format: "%.1f", km)
            distanceText += "公里"
        }else{
            distanceText = "\(distanceTmp)米"
        }
        
        if placeLocation != "" {
            placeLocationLabel.text = placeLocation + " · " + distanceText
        } else {
            placeLocationLabel.text = distanceText
        }
        
    }
    
}
