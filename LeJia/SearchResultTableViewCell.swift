//
//  SearchResultTableViewCell.swift
//  LeJia
//
//  Created by 王嘉宁 on 2017/5/16.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var title: String = "" {
        didSet {
            self.titleLabel.text = title
        }
    }
    var subtitle: String = "" {
        didSet {
            self.subtitleLabel.text = subtitle
        }
    }
    var rightTitle: String = "" {
        didSet {
            self.rightTitleLabel.text = rightTitle
        }
    }
    
    var leftMargin: Int = 20
    
    var titleFontSize: CGFloat = 20
    var subtitleFontSize: CGFloat = 15
    var rightTitleFontSize: CGFloat = 17
    
    var isShowSeparatorLine: Bool = true
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: self.titleFontSize, weight: UIFontWeightMedium)
        l.text = self.title
        l.textColor = .black
        return l
    }()
    
    lazy var subtitleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: CGFloat(self.subtitleFontSize))
        l.text = self.title
        l.textColor = .black
        l.alpha = 0.5
        return l
    }()
    
    lazy var rightTitleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: CGFloat(self.rightTitleFontSize))
        l.text = self.title
        l.textColor = .black
        return l
    }()
    
    lazy var separatorLine: UIView = {
        let v = UIView()
        v.backgroundColor = LJ.grayLine
        return v
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [titleLabel, subtitleLabel, rightTitleLabel].forEach {
            self.contentView.addSubview($0)
        }
        if isShowSeparatorLine {
            self.contentView.addSubview(separatorLine)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rightTitleLabel.snp.makeConstraints { (make) in
            make.width.equalTo(60)
            make.height.equalTo(LJ.controlsHeight)
            make.right.equalToSuperview().offset(-leftMargin)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(leftMargin)
            make.right.equalTo(rightTitleLabel).offset(-70)
            make.height.equalTo(30)
            make.top.equalToSuperview().offset(15)
        }
        
        subtitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(leftMargin)
            make.right.equalTo(rightTitleLabel).offset(-70)
            make.height.equalTo(30)
            make.top.equalTo(titleLabel).offset(30)
        }
        
        if isShowSeparatorLine {
            separatorLine.snp.makeConstraints({ (make) in
                make.height.equalTo(0.5)
                make.bottom.equalToSuperview().offset(-0.5)
                make.left.equalToSuperview().offset(leftMargin)
                make.right.equalToSuperview()
            })
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
    }
    
}
