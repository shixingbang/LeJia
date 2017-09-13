//
//  JNIconLabelTableViewCell.swift
//  LeJia
//
//  Created by 王嘉宁 on 2017/5/14.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import UIKit

class JNIconLabelTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    /** icon*/
    var icon: UIImage = UIImage() {
        didSet {
            log("didSet")
            self.iconImageView.image = icon
        }
    }
    /** title*/
    var title: String = "" {
        didSet {
            self.titleLabel.text = title
        }
    }
    /** icon宽度*/
    var iconWidth: Int = 40
    /** icon左右边距*/
    var iconMargin: Int = 10
    var fontSize: CGFloat = 17
    var isShowSeparatorLine: Bool = false
    
    lazy var iconImageView: UIImageView = {
        let i = UIImageView()
        i.contentMode = .center
        i.image = self.icon
        return i
    }()
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: CGFloat(self.fontSize))
        l.text = self.title
        return l
    }()
    
    lazy var separatorLine: UIView = {
        let v = UIView()
        v.backgroundColor = LJ.redDefault
        return v
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [iconImageView, titleLabel].forEach {
            self.contentView.addSubview($0)
        }
        if isShowSeparatorLine {
            self.contentView.addSubview(separatorLine)
        }
        
        
        iconImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(iconWidth)
            make.left.equalToSuperview().offset(iconMargin)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(2 * iconMargin + iconWidth)
            make.right.equalToSuperview().offset(-2 * iconMargin)
            make.height.equalTo(iconWidth)
            make.centerY.equalToSuperview()
        }
        
        if isShowSeparatorLine {
            separatorLine.snp.makeConstraints({ (make) in
                make.height.equalTo(0.5)
                make.bottom.equalToSuperview().offset(-0.5)
                make.left.equalToSuperview().offset(2 * iconMargin + iconWidth)
                make.right.equalToSuperview()
            })
        }
        log("set")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        log("layoutSubviews")
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
    }

}
