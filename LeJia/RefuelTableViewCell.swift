//
//  RefuelTableViewCell.swift
//  LeJia
//
//  Created by 王嘉宁 on 2017/5/29.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import UIKit

enum CommitOrderHint {
    case shouldSelectGas
    case shouldEnterMoney
    case shouldLogin
}

protocol CommitOrderDelegate {
    func onCommit(_ orderInfo: OrderInfo)
    func onShowHint(_ type: CommitOrderHint)
}

class RefuelTableViewCell: UITableViewCell, UITextFieldDelegate, BundleButtonSelectedChangeDelegate {

    // MARK: - Properties
    
    var delegate: CommitOrderDelegate?
    
    var color: UIColor = .black {
        didSet {
            self.topBackView.backgroundColor = color
            self.moneyTextField.textColor = color
            self.commitOrderButton.color = color
            
            self.oilBundleLabelButtonView.buttonColor = color
            
            // 设置 TextField
            moneyTextField.attributedPlaceholder =
                NSAttributedString(string: "0",
                                   attributes: [NSForegroundColorAttributeName:
                                    color])
            moneyTextField.textColor = color
            
            // 当 cell 再次重用的时候, 清空原来的数据
            self.oilBundleLabelButtonView.buttonSelectedIndex = .none
            self.moneyTextField.text = ""
            self.oilVolumeLabel.titleLabel.text = "0"
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
    
    lazy var addressLabel: DoubleLabelView = {
        let l = DoubleLabelView(.horizontal, leftLabelWidth: 25)
        l.titleLabel.numberOfLines = 0
        return l
    }()
    
    lazy var separatorLine1: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        v.alpha = 0.2
        return v
    }()
    
    lazy var oilBundleLabelButtonView: BundleLabelButtonView = { [unowned self] in
        let l = BundleLabelButtonView(frame: Rect(0, 260, LJ.screenWidth - 20, 90))
        l.mainTitleFont = UIFont.systemFont(ofSize: 15)
        l.delegate = self
        return l
    }()
    
    lazy var separatorLine2: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        v.alpha = 0.2
        return v
    }()
    
    lazy var oilVolumeLabel: DoubleLabelView = {
        let l = DoubleLabelView(.horizontal, leftLabelWidth: 70)
        l.titleLabel.textAlignment = .right
        return l
    }()
    
    lazy var moneyLabel: DoubleLabelView = {
        let l = DoubleLabelView(.horizontal, leftLabelWidth: 70)
        l.titleLabel.textAlignment = .right
        l.titleLabel.text = "元"
        l.subtitleLabel.text = "输入金额"
        return l
    }()
    
    lazy var moneyTextField: UITextField = { [unowned self] in
        let t = UITextField()
        t.borderStyle = .none
        t.textAlignment = .right
        t.keyboardType = .numberPad
        t.delegate = self
        return t
    }()
    
    lazy var separatorLine3: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        v.alpha = 0.2
        return v
    }()
    
    lazy var commitOrderButton: JNActivityButton = { [unowned self] in
        let b = JNActivityButton()
        b.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        b.title = "提交订单"
        b.color = LJ.redDefault
        b.radius = 6
        b.addTarget(self, action: .commit, for: .touchUpInside)
        return b
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(containerView)
        
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 10
        
        [topBackView, topLabel,
         centerImageView, imageBundleLabelView,
         addressLabel, separatorLine1,
         oilBundleLabelButtonView, separatorLine2,
         oilVolumeLabel, moneyLabel,
         moneyTextField, separatorLine3, commitOrderButton].forEach {
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
        
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(LJ.controlsHeight)
            make.bottom.equalTo(centerImageView).offset(50)
        }
        
        separatorLine1.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(0.5)
            make.bottom.equalTo(addressLabel).offset(10)
        }
        
        separatorLine2.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(0.5)
            make.bottom.equalTo(separatorLine1).offset(95)
        }
        
        oilVolumeLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(LJ.controlsHeight - 10)
            make.top.equalTo(separatorLine2).offset(10)
        }
        
        moneyLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(LJ.controlsHeight - 10)
            make.top.equalTo(oilVolumeLabel).offset(LJ.controlsHeight)
        }
        
        moneyTextField.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(LJ.controlsHeight - 10)
            make.top.equalTo(oilVolumeLabel).offset(LJ.controlsHeight)
        }
        
        separatorLine3.snp.makeConstraints { (make) in
            make.left.right.equalTo(moneyTextField)
            make.height.equalTo(0.5)
            make.bottom.equalTo(moneyTextField).offset(-0.5)
        }
        
        commitOrderButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(LJ.controlsHeight - 5)
            make.top.equalTo(moneyTextField).offset(LJ.controlsHeight + 10)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Button Action
    
    func commitOrderButtonTapped() {
        
        guard UserManager.shared.isLogIn else {
            delegate?.onShowHint(.shouldLogin)
            return
        }
        
        let gasButtonSelectedIndex = oilBundleLabelButtonView.buttonSelectedIndex
        
        guard gasButtonSelectedIndex != .none else {
            delegate?.onShowHint(.shouldSelectGas)
            return
        }
        
        guard let money = Int(moneyTextField.text!) else {
            delegate?.onShowHint(.shouldEnterMoney)
            return
        }
        
        let (gasName, gasPrice) = oilBundleLabelButtonView.data[gasButtonSelectedIndex.rawValue]
        
        guard let gasStation = topLabel.text, let address = addressLabel.titleLabel.text else {
            log("nil", .error)
            return
        }
        
        let orderInfo = OrderInfo(gasStation: gasStation,
                                  address: address,
                                  gasName: gasName,
                                  gasPrice: gasPrice,
                                  orderMoney: String(money))
        
        delegate?.onCommit(orderInfo)
        
    }
    
    // MARK: - TextField Delegate
    
    /** 获取实时输入的text*/
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let gasButtonSelectedIndex = oilBundleLabelButtonView.buttonSelectedIndex
        guard gasButtonSelectedIndex != .none else {
            delegate?.onShowHint(.shouldSelectGas)
            return false
        }
        
        guard let text = textField.text as NSString! else {
            updateOilVolumeLabel("0")
            return false
        }
        
        let labelText = text.replacingCharacters(in: range, with: string)
        updateOilVolumeLabel(labelText)
        
        return true
    }
    
    func updateOilVolumeLabel(_ text: String) {
        
        guard let moneyValue = Double(text) else { return }
        
        let gasButtonSelectedIndex = oilBundleLabelButtonView.buttonSelectedIndex
        guard gasButtonSelectedIndex != .none else { return }
        let (_, gasPrice) = oilBundleLabelButtonView.data[gasButtonSelectedIndex.rawValue]
        
        guard let priceValue = Double(gasPrice) else { return }
        
        let resultValue = moneyValue / priceValue
        
        let oilText = String(format: "%.2f", arguments: [resultValue])
        
        oilVolumeLabel.titleLabel.text = oilText + " 升"
        
    }

    // MARK: - BundleButtonSelectedChange Delegate
    
    func buttonSelectedChange(_ selectedIndex: BundleButtonSelectedIndex) {
        guard let text = moneyTextField.text else { return }
        updateOilVolumeLabel(text)
    }
}

fileprivate extension Selector {
    static let commit = #selector(RefuelTableViewCell.commitOrderButtonTapped)
}


