//
//  MyOrderTableViewCell.swift
//  LeJia
//
//  Created by SXB on 2017/6/14.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import UIKit

protocol cancelOrderProtocol {
    func orderCanceled()
}

class MyOrderTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    var delegate: cancelOrderProtocol?
    
    var color: UIColor = .black {
        didSet {
            self.topBackView.backgroundColor = color
            self.cancelOrderButton.color = color
        }
    }
    
    lazy var containerView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    lazy var topBackView: UIView = {
        let v = UIView()
        return v
    }()
    
    lazy var topLabel: UILabel = {
        let l = UILabel()
        l.textColor = .white
        l.font = UIFont.systemFont(ofSize: 14)
        return l
    }()
    
    lazy var centerImageView: UIImageView = {
        let i = UIImageView()
        return i
    }()
    
    lazy var imageBundleLabelView: BundleLabelView = {
        let l = BundleLabelView(frame: Rect(0, 40 + 150 - 60, LJ.screenWidth - 20, 60))
        l.color = .white
        l.setGradientBack = true
        return l
    }()
    
    lazy var orderNumLabel: DoubleLabelView = {
        let v = DoubleLabelView.init(.horizontal, leftLabelWidth: 46, distance: 17)
        v.subtitleLabel.font = UIFont.systemFont(ofSize: 10)
        v.titleLabel.font = UIFont.systemFont(ofSize: 11)
        v.subtitleLabel.text = "订单编号"
//        v.titleLabel.text = "21464791287"
        return v
    }()

    lazy var orderPriLabel: DoubleLabelView = {
        let v = DoubleLabelView.init(.horizontal, leftLabelWidth: 46, distance: 17)
        v.subtitleLabel.font = UIFont.systemFont(ofSize: 10)
        v.titleLabel.font = UIFont.systemFont(ofSize: 11)
        v.subtitleLabel.text = "订单金额"
//        v.titleLabel.text = "200.0元"
        return v
    }()
    
    lazy var addressLabel: DoubleLabelView = {
        let v = DoubleLabelView.init(.horizontal, leftLabelWidth: 23, distance: 40)
        v.subtitleLabel.font = UIFont.systemFont(ofSize: 10)
        v.titleLabel.font = UIFont.systemFont(ofSize: 10)
        v.subtitleLabel.text = "地址"
        v.titleLabel.numberOfLines = 0
//        v.titleLabel.text = "北京市崇文区天坛路12号，与东市场东街路交叉西南角（天坛北门往西一公里路南）"
        return v
    }()
    
    lazy var separatorLine1: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        v.alpha = 0.2
        return v
    }()

    lazy var qrLabel: UILabel = {
        let l = UILabel()
        l.text = "二维码"
        l.font = UIFont.systemFont(ofSize: 10)
        l.alpha = 0.5
        return l
    }()
    
    lazy var qrImageView: UIImageView = {
        let v = UIImageView()
//        v.image = #imageLiteral(resourceName: "test_avatar2")
        return v
    }()
    
    lazy var cancelOrderButton: JNActivityButton = { [unowned self] in
        let b = JNActivityButton()
        b.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        b.title = "取消订单"
        b.color = LJ.redDefault
        b.radius = 6
        b.addTarget(self, action: .cancelOrder, for: .touchUpInside)
        return b
        }()
    
    // MARK: - Action 
    func cancelOrder() {
        delegate?.orderCanceled()
    }
    
    // MARK: - Init
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(containerView)
        
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 10
        
        [topBackView, topLabel,
         centerImageView, imageBundleLabelView, orderNumLabel, orderPriLabel, addressLabel, separatorLine1, qrLabel, qrImageView, cancelOrderButton ].forEach {
            containerView.addSubview($0)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        containerView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        
        topBackView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(LJ.controlsHeight)
        }
        
        topLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(LJ.controlsHeight)
            make.centerY.equalTo(topBackView)
        }
        
        centerImageView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(150)
            make.top.equalTo(topBackView).offset(LJ.controlsHeight)
        }

        orderNumLabel.snp.makeConstraints {
            (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(201)
            make.height.equalTo(20)
        }
        
        orderPriLabel.snp.makeConstraints {
            (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(226)
            make.height.equalTo(20)
        }
        
        addressLabel.snp.makeConstraints {
            (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(253)
            make.height.equalTo(32)
        }

        separatorLine1.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(0.5)
            make.top.equalToSuperview().offset(293)
        }

        qrLabel.snp.makeConstraints {
            (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(303)
            make.width.equalTo(34)
            make.height.equalTo(16)
        }
        
        qrImageView.snp.makeConstraints {
            (make) in
            make.left.equalToSuperview().offset(84)
            make.top.equalToSuperview().offset(302)
            make.height.width.equalTo(199)
        }
        
        cancelOrderButton.snp.makeConstraints {
            (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(510)
            make.height.equalTo(31)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

fileprivate extension Selector {
    static let cancelOrder = #selector(MyOrderTableViewCell.cancelOrder)
}
