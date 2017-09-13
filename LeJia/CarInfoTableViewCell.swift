//
//  CarInfoTableViewCell.swift
//  LeJia
//
//  Created by SXB on 2017/6/8.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import UIKit
import Alamofire

protocol checkMaintainingDelegate {
    func onCheckMaintaining() 
}

class CarInfoTableViewCell: UITableViewCell {

    // MARK: - Properties
    var color: UIColor = .black {
        didSet {
            self.topBackView.backgroundColor = color
            self.checkMaintainingButton.color = color
//            self.moneyTextField.textColor = color
//            self.commitOrderButton.color = color
//            
//            self.oilBundleLabelButtonView.buttonColor = color
//            
//            // 设置 TextField
//            moneyTextField.attributedPlaceholder =
//                NSAttributedString(string: "0",
//                                   attributes: [NSForegroundColorAttributeName:
//                                    color])
//            moneyTextField.textColor = color
//            
//            // 当 cell 再次重用的时候, 清空原来的数据
//            self.oilBundleLabelButtonView.buttonSelectedIndex = .none
//            self.moneyTextField.text = ""
//            self.oilVolumeLabel.titleLabel.text = "0"
        }
    }

    var checkDelegate: checkMaintainingDelegate?
    
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
    
    lazy var brandLabel: DoubleLabelView = {
        let l = DoubleLabelView.init(.vertical, labelHeight: 16)
        l.titleLabel.font = UIFont.systemFont(ofSize: 10)
        l.subtitleLabel.font = UIFont.systemFont(ofSize: 10)
        l.titleLabel.textColor = UIColor.white
        l.subtitleLabel.textColor = UIColor.white
//        l.titleLabel.text = "奔驰"
        l.subtitleLabel.text = "品牌"
        return l
    }()
    
    lazy var versionNumberLabel: DoubleLabelView = {
        let l = DoubleLabelView.init(.vertical, labelHeight: 16)
        l.titleLabel.font = UIFont.systemFont(ofSize: 10)
        l.subtitleLabel.font = UIFont.systemFont(ofSize: 10)
        l.titleLabel.textColor = UIColor.white
        l.subtitleLabel.textColor = UIColor.white
//        l.titleLabel.text = "C 180 L"
        l.subtitleLabel.text = "型号"
        return l
    }()

    lazy var archImageView: UIImageView = {
        let i = UIImageView.init(image: #imageLiteral(resourceName: "test_avatar2"))
        return i
    }()
    
    lazy var plateNumberLabel: DoubleLabelView = {
        let l = DoubleLabelView.init(.vertical, subLabelHeight: 16)
        l.subtitleLabel.font = UIFont.systemFont(ofSize: 10)
//        l.titleLabel.text = "鲁A706U"
        l.subtitleLabel.text = "车牌"
        return l
    }()
    
    lazy var leftOilLabel: DoubleLabelView = {
        let l = DoubleLabelView.init(.vertical, subLabelHeight: 16)
        l.subtitleLabel.font = UIFont.systemFont(ofSize: 10)
//        l.titleLabel.text = "50%"
        l.subtitleLabel.text = "剩余油量"
        return l
    }()

    lazy var separatorLine1: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        v.alpha = 0.2
        return v
    }()
    
    lazy var archNumberSubLabel: UILabel = {
       let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 10)
        l.text = "车架号"
        l.alpha = 0.5
        return l
    }()
    
    lazy var motorNumberSubLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 10)
        l.text = "发动机号"
        l.alpha = 0.5
        return l
    }()

    lazy var distanceSubLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 10)
        l.text = "里程数"
        l.alpha = 0.5
        return l
    }()
    
    lazy var archNumberLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 11)
//        l.text = "LFV2A1151C3760867"
        return l
    }()

    lazy var motorNumberLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 11)
//        l.text = "S65901"
        return l
    }()
    
    lazy var distanceLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 11)
//        l.text = "58238公里"
        return l
    }()
    
    lazy var separatorLine2: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        v.alpha = 0.2
        return v
    }()

    lazy var performanceBundleLabelView: BundleLabelView = {
        let l = BundleLabelView(frame: Rect(0, 311, LJ.screenWidth - 20, 60))
//        l.leftLabel.titleLabel.text = "正常"
        l.leftLabel.subtitleLabel.text = "发动机性能"
//        l.centerLabel.titleLabel.text = "正常"
        l.centerLabel.subtitleLabel.text = "变速器性能"
//        l.rightLabel.titleLabel.text = "正常"
        l.rightLabel.subtitleLabel.text = "车灯性能"
        return l
    }()

    lazy var checkMaintainingButton: JNActivityButton = { [unowned self] in
        let b = JNActivityButton()
        b.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        b.title = "检查维修"
        b.color = LJ.redDefault
        b.radius = 6
        b.addTarget(self, action: .check, for: .touchUpInside)
        return b
        }()
    
    // MARK: - Init
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(containerView)
        
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 10
        
        [topBackView, topLabel,
         centerImageView, brandLabel, versionNumberLabel, archImageView, plateNumberLabel, leftOilLabel, separatorLine1, archNumberSubLabel, motorNumberSubLabel, distanceSubLabel, archNumberLabel, motorNumberLabel, distanceLabel, separatorLine2, performanceBundleLabelView, checkMaintainingButton
         ].forEach {
            containerView.addSubview($0)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.snp.makeConstraints{
            (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
    
        topBackView.snp.makeConstraints{
            (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(LJ.controlsHeight)
        }
        
        topLabel.snp.makeConstraints {
            (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(LJ.controlsHeight)
            make.centerY.equalTo(topBackView)
        }
        
        centerImageView.snp.makeConstraints {
            (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
            make.top.equalTo(topBackView).offset(LJ.controlsHeight)
        }
        
        brandLabel.snp.makeConstraints {
            (make) in
            make.left.equalToSuperview().offset(25)
            make.top.equalToSuperview().offset(100)
            make.height.equalTo(LJ.controlsHeight - 8)
        }
        
        versionNumberLabel.snp.makeConstraints {
            (make) in
            make.right.equalToSuperview().offset(-25)
            make.top.equalToSuperview().offset(100)
            make.height.equalTo(LJ.controlsHeight - 8)
        }
        
        archImageView.snp.makeConstraints {
            (make) in
            make.left.equalToSuperview().offset(13)
            make.top.equalToSuperview().offset(155)
            make.width.height.equalTo(50)
        }
        
        plateNumberLabel.snp.makeConstraints {
            (make) in
            make.left.equalTo(archImageView).offset(69)
            make.top.equalTo(archImageView)
            make.height.equalTo(LJ.controlsHeight - 4)
        }
        
        leftOilLabel.snp.makeConstraints {
            (make) in
            make.right.equalToSuperview().offset(-43)
            make.top.equalTo(archImageView)
            make.height.equalTo(LJ.controlsHeight - 4)
        }
        
        separatorLine1.snp.makeConstraints {
            (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(220)
            make.height.equalTo(0.5)
        }
        
        archNumberSubLabel.snp.makeConstraints {
            (make) in
            make.left.equalToSuperview().offset(13)
            make.top.equalTo(separatorLine1).offset(9)
            make.height.equalTo(16)
            make.width.equalTo(34)
        }
        
        motorNumberSubLabel.snp.makeConstraints {
            (make) in
            make.left.equalToSuperview().offset(13)
            make.top.equalTo(separatorLine1).offset(37)
            make.height.equalTo(16)
            make.width.equalTo(46)
        }
        
        distanceSubLabel.snp.makeConstraints {
            (make) in
            make.left.equalToSuperview().offset(13)
            make.top.equalTo(separatorLine1).offset(62)
            make.height.equalTo(16)
            make.width.equalTo(42)
        }
        
        archNumberLabel.snp.makeConstraints {
            (make) in
            make.left.equalToSuperview().offset(82)
            make.top.equalTo(archNumberSubLabel)
            make.height.equalTo(archNumberSubLabel)
            make.right.equalToSuperview()
        }
        
        motorNumberLabel.snp.makeConstraints {
            (make) in
            make.left.equalToSuperview().offset(82)
            make.top.equalTo(motorNumberSubLabel)
            make.height.equalTo(motorNumberSubLabel)
            make.right.equalToSuperview()
        }
        
        distanceLabel.snp.makeConstraints {
            (make) in
            make.left.equalToSuperview().offset(82)
            make.top.equalTo(distanceSubLabel)
            make.height.equalTo(distanceSubLabel)
            make.right.equalToSuperview()
        }
        
        separatorLine2.snp.makeConstraints {
            (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(0.5)
            make.top.equalToSuperview().offset(311)
        }
        
        checkMaintainingButton.snp.makeConstraints {
            (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(LJ.controlsHeight - 9)
            make.top.equalTo(separatorLine2).offset(58)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Button Action 
    func checkMaintainingButtonTapped() {
        Alamofire.request(Router.checkCarInfo(UserManager.shared.getToken())).responseJSON {
            response in
            switch response.result {
            case .success:
                guard let value = response.result.value else {
                    log("response.result.value is nil", .error)
                    return
                }
                let json = JSON(value)
                print("checkMaintaining result: " )
                print(json)
            case .failure(let error):
                self.clearAllNotice()
                self.noticeError("获取失败")
                log(error, .error)
            }
            
        }
    }
}

fileprivate extension Selector {
    static let check = #selector(CarInfoTableViewCell.checkMaintainingButtonTapped)
}
