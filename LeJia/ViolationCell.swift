//
//  ViolationCell.swift
//  LeJia
//
//  Created by SXB on 2017/6/22.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import UIKit

class ViolationCell: UITableViewCell {
    
    // MARK: - Properties
    lazy var carLogoImageView: UIImageView = {
        let v = UIImageView()
        v.image = #imageLiteral(resourceName: "lifestyle_btn_car")
        return v
    }()

    var carBrandLabel: UILabel = {
        let l = UILabel()
        l.text = "奔驰 X5"
        l.font = UIFont.systemFont(ofSize: 17)
        return l
    }()
    
    var plateLabel: UILabel = {
        let l = UILabel()
        l.text = "车牌号：鲁A6435"
        l.font = UIFont.systemFont(ofSize: 16)
        l.alpha = 0.5
        return l
    }()
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [carLogoImageView, carBrandLabel, plateLabel].forEach{
            self.addSubview($0)
        }
        
        carLogoImageView.snp.makeConstraints {
            (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            make.width.height.equalTo(60)
        }
        
        carBrandLabel.snp.makeConstraints {
            (make) in
            make.top.equalToSuperview().offset(15)
            make.left.equalTo(carLogoImageView).offset(60+10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(20)
        }
        
        plateLabel.snp.makeConstraints {
            (make) in
            make.top.equalTo(carBrandLabel).offset(20+5)
            make.left.equalTo(carBrandLabel)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
