//
//  SignupViewController.swift
//  LeJia
//
//  Created by 王嘉宁 on 2017/5/28.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    lazy var backImageView: UIImageView = {
        let i = UIImageView()
        i.image = #imageLiteral(resourceName: "signUp_background")
        return i
    }()
    
    lazy var contentView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }()
    
    lazy var photoButton: UIButton = { [unowned self] in
        let b = UIButton()
        b.addTarget(self, action: .photo, for: .touchUpInside)
        b.setImage(#imageLiteral(resourceName: "signup_btn_photo"), for: .normal)
        b.layer.masksToBounds = true
        b.layer.cornerRadius = 60
        return b
    }()
    
    lazy var phoneTextField: JNIconTextField = { [unowned self] in
        let t = JNIconTextField(icon: #imageLiteral(resourceName: "signup_icon_phone"))
        t.placeholder = "输入手机号"
        t.font = UIFont.systemFont(ofSize: 13)
        t.textColor = .white
        t.placeholderColor = .white
        t.separatorColor = .white
        t.delegate = self
        t.keyboardType = .numberPad
        return t
    }()
    
    lazy var messageTextField: JNIconTextField = { [unowned self] in
        let t = JNIconTextField()
        t.icon = #imageLiteral(resourceName: "signup_icon_message")
        t.placeholder = "短信验证码"
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
        t.placeholder = "输入密码"
        t.font = UIFont.systemFont(ofSize: 13)
        t.textColor = .white
        t.placeholderColor = .white
        t.separatorColor = .white
        t.delegate = self
        t.isSecureTextEntry = true
        return t
    }()
    
    lazy var emailTextField: JNIconTextField = { [unowned self] in
        let t = JNIconTextField()
        t.icon = #imageLiteral(resourceName: "signup_icon_message")
        t.placeholder = "输入邮箱"
        t.font = UIFont.systemFont(ofSize: 13)
        t.textColor = .white
        t.placeholderColor = .white
        t.separatorColor = .white
        t.delegate = self
        return t
    }()
    
    lazy var nameTextField: JNIconTextField = { [unowned self] in
        let t = JNIconTextField()
        t.icon = #imageLiteral(resourceName: "signup_icon_username")
        t.placeholder = "输入昵称"
        t.font = UIFont.systemFont(ofSize: 13)
        t.textColor = .white
        t.placeholderColor = .white
        t.separatorColor = .white
        t.delegate = self
        return t
    }()

    lazy var getMessageButton: JNMessageButton = { [unowned self] in
        let b = JNMessageButton()
        b.color = LJ.redDefault
        b.radius = 30 / 2
        b.addTarget(self, action: .getMessage, for: .touchUpInside)
        return b
    }()
    
    lazy var signupButton: JNActivityButton = { [unowned self] in
        let b = JNActivityButton()
        b.addTarget(self, action: .signup, for: .touchUpInside)
        b.title = "注册"
        b.color = LJ.redDefault
        b.radius = 55/2
        return b
    }()
    
    let notification = NotificationCenter.default
    
    lazy var chooseAlertController: UIAlertController = {
        let a = UIAlertController()
        let chooseCamera = UIAlertAction(title: "拍照", style: .default) { alert in
            self.imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let chooseAlbum = UIAlertAction(title: "相册", style: .default) { arlert in
            self.imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { arlert in
            log("cancel")
        }
        a.addAction(chooseCamera)
        a.addAction(chooseAlbum)
        a.addAction(cancelAction)
        return a
    }()
    lazy var imagePickerController: UIImagePickerController = { [unowned self] in
        let i = UIImagePickerController()
        i.delegate = self
        i.allowsEditing = true
        return i
    }()
    
    fileprivate var avatarImageData: NSData!
    
    /** signupButton按钮与底部的约束*/
    var bottomConstraint: NSLayoutConstraint?
    
    var isPushLoad = true {
        didSet {
            if !isPushLoad {
                initCloseButton()
            }
        }
    }
    
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
        
        // 设置导航栏透明
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        initUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 监听键盘弹出
        notification.addObserver(self, selector: .keyboardWillShow, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notification.addObserver(self, selector: .keyboardWillHide, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        UserManager.addObserver(observer: self, selector: .userDidGetMsg, notification: .didGetMessage)
        UserManager.addObserver(observer: self, selector: .userDidGetMsgFailure, notification: .didGetMessageFailure)
        UserManager.addObserver(observer: self, selector: .userDidSignup, notification: .didSignup)
        UserManager.addObserver(observer: self, selector: .userDidSignupFailure, notification: .didSignupFailure)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        notification.removeObserver(self)
        UserManager.removeObserver(observer: self, notification: .didGetMessage)
        UserManager.removeObserver(observer: self, notification: .didGetMessageFailure)
        UserManager.removeObserver(observer: self, notification: .didSignup)
        UserManager.removeObserver(observer: self, notification: .didSignupFailure)
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
        
        [photoButton, phoneTextField,
         messageTextField, passwordTextField, emailTextField,
         nameTextField, getMessageButton,
         signupButton].forEach {
            contentView.addSubview($0)
        }
        
        signupButton.snp.makeConstraints { (make) in
            make.height.equalTo(55)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-50).priority(600)
        }
        
        emailTextField.snp.makeConstraints { (make) in
            make.height.equalTo(LJ.controlsHeight)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.bottom.equalTo(signupButton).offset(-LJ.controlsMargin - 30)
        }
        
        nameTextField.snp.makeConstraints { (make) in
            make.height.equalTo(LJ.controlsHeight)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.bottom.equalTo(emailTextField).offset(-LJ.controlsMargin)
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            make.height.equalTo(LJ.controlsHeight)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.bottom.equalTo(nameTextField).offset(-LJ.controlsMargin)
        }
        
        getMessageButton.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.width.equalTo(80)
            make.right.equalToSuperview().offset(-40)
            make.bottom.equalTo(passwordTextField).offset(-LJ.controlsMargin)
        }
        
        messageTextField.snp.makeConstraints { (make) in
            make.height.equalTo(LJ.controlsHeight)
            make.left.equalToSuperview().offset(40)
            make.right.equalTo(getMessageButton).offset(-100)
            make.bottom.equalTo(passwordTextField).offset(-LJ.controlsMargin)
        }
        
        phoneTextField.snp.makeConstraints { (make) in
            make.height.equalTo(LJ.controlsHeight)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.bottom.equalTo(messageTextField).offset(-LJ.controlsMargin)
        }
        
        photoButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(120)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(phoneTextField).offset(-LJ.controlsMargin - 10)
        }
        
    }
    
    // MARK: - Button Action
    
    func photoButtonTapped(_ sender: UIButton) {
        
        self.present(chooseAlertController, animated: true, completion: nil)
    }
    
    func getMessageButtonTapped(_ sender: UIButton) {
        
        let phoneNum: String = {
            guard let phone = phoneTextField.text else { return "" }
            return phone
        }()
        
        guard phoneNum.characters.count == 11 else {
            self.noticeOnlyText("手机号不合法")
            return
        }
        
        getMessageButton.isActive = true
        
        UserManager.shared.getMessage(phoneNum)
    }
    
    func signupButtonTapped(_ sender: UIButton) {
        
        guard isValidPhone(phoneTextField.text) else {
            self.noticeOnlyText("请输入合法手机号")
            return
        }
        
        guard isValidMessageCode(messageTextField.text) else {
            self.noticeOnlyText("短信验证码不合法")
            return
        }
        
        guard isValidPassword(passwordTextField.text) else {
            self.noticeOnlyText("密码必须六位以上")
            return
        }
        
        guard let name = nameTextField.text else {
            self.noticeOnlyText("昵称不能为空")
            return
        }
        
        guard isValidEmail(emailTextField.text) else {
            self.noticeOnlyText("请输入合法邮箱")
            return
        }
        
        guard let data = avatarImageData else {
            self.noticeOnlyText("请设置头像")
            return
        }
        
        let photo = data.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        
        signupButton.isActive = true
        UserManager.shared.signup(username: phoneTextField.text!,
                                  password: messageTextField.text!,
                                  name: name,
                                  email: emailTextField.text!,
                                  photo: photo)
    }
    
    
    // MARK: - Notifier Action
    
    func userDidGetMsg(notification: NSNotification) {
        getMessageButton.isActive = true
        self.noticeTop("获取短信验证码成功")
        messageTextField.text = "123456"
    }
    
    func userDidGetMsgFailure(notification: NSNotification) {
        getMessageButton.isActive = false
        self.noticeError("获取失败")
    }
    
    func userDidSignup(notification: NSNotification) {
        signupButton.isActive = false
        self.noticeSuccess("注册成功")
        
        guard let navigationController = navigationController else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            navigationController.popViewController(animated: true)
        })
    }
    
    func userDidSignupFailure(notification: NSNotification) {
        signupButton.isActive = false
        self.noticeError("注册失败")
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
    
    /** 根据键盘高度更新约束*/
    func updateViewConstraintsForKeyboardHeight(_ keyboardHeight: CGFloat) {
        
        if bottomConstraint != nil {
            self.view.removeConstraints([bottomConstraint!])
            bottomConstraint = nil
        }
        
        if keyboardHeight != 0 {
            bottomConstraint = NSLayoutConstraint(item: self.contentView,
                                                  attribute: NSLayoutAttribute.bottom,
                                                  relatedBy: NSLayoutRelation.equal,
                                                  toItem: self.signupButton,
                                                  attribute: NSLayoutAttribute.bottom,
                                                  multiplier: 1.0,
                                                  constant: keyboardHeight + 10)
            self.view.addConstraints([bottomConstraint!])
        }
        self.view.layoutIfNeeded()
    }
    
    // MARK: - ImagePickerController Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        var image:UIImage!
        
        if(picker.allowsEditing){
            image = info[UIImagePickerControllerEditedImage] as! UIImage
        }else{
            image = info[UIImagePickerControllerOriginalImage] as! UIImage
        }

        let compressionQuality:CGFloat = 1
        let photoData = UIImageJPEGRepresentation(image, compressionQuality)
        self.avatarImageData = photoData! as NSData
        let photo = UIImage(data: photoData!)
        self.photoButton.setImage(photo, for: .normal)
    }
    
    // MARK: - TextField Delegate
    
    /** 点击return隐藏键盘*/
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /** 点击其他区域隐藏键盘*/
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        textFieldResignFirstResponder()
    }
    
    func textFieldResignFirstResponder() {
        [phoneTextField, messageTextField,
         passwordTextField, nameTextField].forEach {
            $0.resignFirstResponder()
        }
    }
    
    // MARK: - Close Button 
    // 不是Push过来的需要设置
    
    func initCloseButton() {
        let closeButton = UIButton()
        closeButton.setImage(#imageLiteral(resourceName: "signup_button_close"), for: .normal)
        closeButton.addTarget(self, action: #selector(SignupViewController.closeButtonTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.top.equalTo(30)
            make.left.equalTo(15)
        }
    }
    
    func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}

fileprivate extension Selector {
    static let photo = #selector(SignupViewController.photoButtonTapped(_:))
    static let getMessage = #selector(SignupViewController.getMessageButtonTapped(_:))
    static let signup = #selector(SignupViewController.signupButtonTapped(_:))
    static let keyboardWillShow = #selector(SignupViewController.keyboardWillShow)
    static let keyboardWillHide = #selector(SignupViewController.keyboardWillHide)
}


