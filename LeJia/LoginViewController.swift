//
//  LoginViewController.swift
//  LeJia
//
//  Created by 王嘉宁 on 2017/5/26.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController, UITextFieldDelegate {
        
    // MARK: - Properties
    
    lazy var backImageView: UIImageView = {
        let i = UIImageView()
        i.image = #imageLiteral(resourceName: "login_background")
        return i
    }()
    
    lazy var contentView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }()
    
    lazy var logoImageView: UIImageView = {
        let i = UIImageView()
        i.image = #imageLiteral(resourceName: "test_login_logo")
        return i
    }()
    
    lazy var welcomeLabel: UILabel = {
        let l = UILabel()
        l.text = "欢迎来到乐驾"
        l.font = UIFont.systemFont(ofSize: 16)
        l.textColor = .white
        return l
    }()
    
    lazy var phoneTextField: JNIconTextField = { [unowned self] in
        let t = JNIconTextField(icon: #imageLiteral(resourceName: "signup_icon_phone"))
        t.placeholder = "手机号"
        t.font = UIFont.systemFont(ofSize: 13)
        t.textColor = .white
        t.placeholderColor = .white
        t.separatorColor = .white
        t.delegate = self
        t.keyboardType = .numberPad
        return t
    }()

    lazy var passwordTextField: JNIconTextField = { [unowned self] in
        let t = JNIconTextField()
        t.icon = #imageLiteral(resourceName: "signup_icon_password")
        t.placeholder = "密码"
        t.font = UIFont.systemFont(ofSize: 13)
        t.textColor = .white
        t.placeholderColor = .white
        t.separatorColor = .white
        t.delegate = self
        t.isSecureTextEntry = true
        return t
    }()
    
    lazy var loginButton: JNActivityButton = { [unowned self] in
        let b = JNActivityButton()
        b.addTarget(self, action: .login, for: .touchUpInside)
        b.title = "登录"
        b.color = LJ.redDefault
        b.radius = 55/2
        return b
    }()
    
    lazy var inquireLabel: UILabel = {
        let l = UILabel()
        l.text = "还没有账号?"
        l.font = UIFont.systemFont(ofSize: 13)
        l.textColor = .white
        l.alpha = 0.5
        return l
    }()
    
    lazy var signupLabel: UILabel = {
        let l = UILabel()
        l.text = "注册"
        l.font = UIFont.systemFont(ofSize: 13)
        l.textColor = .white
        return l
    }()
    
    lazy var showSignUpButton: UIButton = { [unowned self] in
        let b = UIButton()
        b.addTarget(self, action: .showSignup, for: .touchUpInside)
        return b
    }()
    
    let notification = NotificationCenter.default
    
    /** loginButton按钮与底部的约束*/
    var bottomConstraint: NSLayoutConstraint?
    /** logo的宽度约束*/
    var widthConstraint: NSLayoutConstraint?
    /** logo的高度约束*/
    var heightConstraint: NSLayoutConstraint?
    /** welcomeLabel与logo的顶部约束*/
    var topConstraint: NSLayoutConstraint?
    
    // MARK: - Lifecycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray
        
        if let navigationController = self.navigationController {
            // 导航栏透明
            navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController.navigationBar.shadowImage = UIImage()
            navigationController.navigationBar.isTranslucent = true
            
            // 设置返回按钮
            navigationController.navigationBar.backIndicatorImage = UIImage()
            navigationController.navigationBar.backIndicatorTransitionMaskImage = UIImage()
            let item = UIBarButtonItem()
            item.image = #imageLiteral(resourceName: "signup_button_back")
            navigationItem.backBarButtonItem = item
        }
        
        initUI()
        initCloseButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 监听键盘弹出
        notification.addObserver(self, selector: .keyboardWillShow, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notification.addObserver(self, selector: .keyboardWillHide, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        UserManager.addObserver(observer: self, selector: .userDidLogin, notification: .didLogin)
        UserManager.addObserver(observer: self, selector: .userDidLoginFailure, notification: .didLoginFailure)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        notification.removeObserver(self)
        UserManager.removeObserver(observer: self, notification: .didLogin)
        UserManager.removeObserver(observer: self, notification: .didLoginFailure)
        textFieldResignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Init
    
    func initUI() {
        [backImageView, contentView].forEach {
            view.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.left.top.right.bottom.equalToSuperview()
            }
        }

        [logoImageView, welcomeLabel,
         phoneTextField, passwordTextField,
         loginButton, showSignUpButton].forEach {
            contentView.addSubview($0)
        }
        
        logoImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(120).priority(600)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(LJ.controlsMargin)
        }
        
        welcomeLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView).offset(140).priority(600)
        }
        
        showSignUpButton.snp.makeConstraints { (make) in
            make.width.equalTo(110)
            make.height.equalTo(30)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50)
        }
        
        [inquireLabel, signupLabel].forEach {
            showSignUpButton.addSubview($0)
        }
        
        inquireLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
        }
        
        signupLabel.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.height.equalTo(55)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(showSignUpButton).offset(-50).priority(600)
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            make.height.equalTo(LJ.controlsHeight)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.bottom.equalTo(loginButton).offset(-90)
        }
        
        phoneTextField.snp.makeConstraints { (make) in
            make.height.equalTo(LJ.controlsHeight)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.bottom.equalTo(passwordTextField).offset(-LJ.controlsMargin)
        }
        
    }
    
    // MARK: - Button Action
    
    func loginButtonTapped(_ sender: UIButton) {
        guard isValidPhone(phoneTextField.text) else {
            self.noticeOnlyText("请输入合法手机号")
            return
        }
        
        guard isValidPassword(passwordTextField.text) else {
            self.noticeOnlyText("请输入合法密码")
            return
        }
        
        textFieldResignFirstResponder()
        
        loginButton.isActive = true
        
        UserManager.shared.login(username: phoneTextField.text!,
                                 password: passwordTextField.text!)
    }
    
    func showSignupButtonTapped(_ sender: UIButton) {
        let signupViewController = SignupViewController()
        self.navigationController?.pushViewController(signupViewController, animated: true)
    }
    
    // MARK: - Notifier Action
    
    func userDidLogin(notification: NSNotification) {
        loginButton.isActive = false
        self.noticeSuccess("登录成功")
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.closeButtonTapped()
        })
    }
    
    func userDidLoginFailure(notification: NSNotification) {
        loginButton.isActive = false
        self.noticeError("登录失败")
    }
    
    // MARK: - Notification
    
    func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo as NSDictionary! else { return }
        guard let keyboardHeight = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height else { return }
        guard let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else { return }
        guard let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber else { return }
        
        UIView.animate(withDuration: duration.doubleValue) { 
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve.intValue)!)
            self.updateViewConstraintsForKeyboardHeight(keyboardHeight)
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo as NSDictionary! else { return }
        guard let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else { return }
        guard let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber else { return }
        
        UIView.animate(withDuration: duration.doubleValue) {
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve.intValue)!)
            self.updateViewConstraintsForKeyboardHeight(0)
        }
        
    }
    
    func updateViewConstraintsForKeyboardHeight(_ keyboardHeight: CGFloat) {
        
        if bottomConstraint != nil {
            self.view.removeConstraints([bottomConstraint!, widthConstraint!, heightConstraint!, topConstraint!])
            bottomConstraint = nil
            widthConstraint = nil
            heightConstraint = nil
            topConstraint = nil
        }
        
        if keyboardHeight != 0 {
            bottomConstraint = NSLayoutConstraint(item: self.contentView,
                                                  attribute: NSLayoutAttribute.bottom,
                                                  relatedBy: NSLayoutRelation.equal,
                                                  toItem: self.loginButton,
                                                  attribute: NSLayoutAttribute.bottom,
                                                  multiplier: 1.0,
                                                  constant: keyboardHeight + 10)
            widthConstraint = NSLayoutConstraint(item: self.logoImageView,
                                                 attribute: NSLayoutAttribute.width,
                                                 relatedBy: NSLayoutRelation.equal,
                                                 toItem: nil,
                                                 attribute: NSLayoutAttribute.notAnAttribute,
                                                 multiplier: 1.0,
                                                 constant: 60)
            heightConstraint = NSLayoutConstraint(item: self.logoImageView,
                                                  attribute: NSLayoutAttribute.height,
                                                  relatedBy: NSLayoutRelation.equal,
                                                  toItem: nil,
                                                  attribute: NSLayoutAttribute.notAnAttribute,
                                                  multiplier: 1.0,
                                                  constant: 60)
            topConstraint = NSLayoutConstraint(item: self.welcomeLabel,
                                               attribute: NSLayoutAttribute.top,
                                               relatedBy: NSLayoutRelation.equal,
                                               toItem: self.logoImageView,
                                               attribute: NSLayoutAttribute.top,
                                               multiplier: 1.0,
                                               constant: 60 + 20)
            self.view.addConstraints([bottomConstraint!, widthConstraint!, heightConstraint!, topConstraint!])
        }
        self.view.layoutIfNeeded()
    }
    
    // MARK: - TextField Delegate
    
    /** 点击return隐藏键盘*/
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /** 点击其他区域隐藏键盘*/
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !phoneTextField.isExclusiveTouch {
            phoneTextField.resignFirstResponder()
        }
        if !passwordTextField.isExclusiveTouch {
            passwordTextField.resignFirstResponder()
        }
        //textFieldResignFirstResponder()
    }
    
    func textFieldResignFirstResponder() {
        phoneTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    // MARK: - Close Button
    
    func initCloseButton() {
        let closeButton = UIButton(frame: Rect(0, 0, 30, 30))
        closeButton.setImage(#imageLiteral(resourceName: "signup_button_close"), for: .normal)
        closeButton.addTarget(self, action: #selector(LoginViewController.closeButtonTapped), for: .touchUpInside)

        let barItem = UIBarButtonItem(customView: closeButton)
        self.navigationItem.leftBarButtonItem = barItem
    }
    
    func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }

}

fileprivate extension Selector {
    static let login = #selector(LoginViewController.loginButtonTapped(_:))
    static let showSignup = #selector(LoginViewController.showSignupButtonTapped(_:))
    static let keyboardWillShow = #selector(LoginViewController.keyboardWillShow)
    static let keyboardWillHide = #selector(LoginViewController.keyboardWillHide)
    
}
