//
//  LeftViewController.swift
//  LeJia
//
//  Created by 王嘉宁 on 2017/5/14.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import UIKit
import SnapKit

class LeftViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    fileprivate var data: [[(UIImage, String, UIViewController)]]
    
    fileprivate let cellIdentifier = "leftCell"
    
    lazy var backImageView: UIImageView = {
        let i = UIImageView()
        i.image = #imageLiteral(resourceName: "left_background")
        return i
    }()
    
    let profileView = LeftProfileView()
    
    lazy var tableView: UITableView = { [unowned self] in
        let t = UITableView(frame: .zero, style: .grouped) // section header 跟随滑动
        t.backgroundColor = UIColor.clear
        t.separatorStyle = .none
        t.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: LJ.leftMenuWidth, height: 5))
//        t.tableFooterView = UIView() // 消除空白行
        t.sectionFooterHeight = 1.0 // 减小 section 之间的间距
        t.dataSource = self
        t.delegate = self
        return t
    }()
    
    var isUserLogonIn = false {
        didSet {
            tableView.reloadData()
            if !isUserLogonIn {
                self.profileView.avatar = #imageLiteral(resourceName: "left_icon_defaultAvatar")
                self.profileView.userRealName = "未登录"
            }
        }
    }
    
    fileprivate let loginData: [(UIImage, String)] =
        [(#imageLiteral(resourceName: "left_icon_logOut"), "退 出")]
    
    fileprivate let logoutData: [(UIImage, String)] =
        [(#imageLiteral(resourceName: "left_icon_logIn"), "登 录"),
         (#imageLiteral(resourceName: "left_icon_logOut"), "注 册")]
    
    // MARK: - Lifecycle
    
    init(data: [[(UIImage, String, UIViewController)]]) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = LJ.grayDefault
        UserManager.addObserver(observer: self, selector: .userDidGetUserInfo, notification: .didGetUserInfo)
        UserManager.addObserver(observer: self, selector: .userDidGetUserInfoFailure, notification: .didGetUserInfoFailure)
        UserManager.addObserver(observer: self, selector: .userDidGetUserAvatar, notification: .didGetUserAvatar)
        UserManager.addObserver(observer: self, selector: .userDidGetUserAvatarFailure, notification: .didGetUserAvatarFailure)
        
        initUI()
    }
    
    deinit {
        UserManager.removeObserver(observer: self, notification: .didGetUserAvatar)
        UserManager.removeObserver(observer: self, notification: .didGetUserAvatarFailure)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Init
    
    func initUI() {
        
        [backImageView, profileView,
         tableView].forEach {
            self.view.addSubview($0)
        }
        
        // backView
        backImageView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        // profile
        profileView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(LJ.controlsMargin * 3)
        }
        
        // tableView
        tableView.register(SlideMenuTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(profileView).offset(LJ.controlsMargin * 3)
            make.bottom.left.right.equalToSuperview()
        }
        tableView.reloadData()
        
    }
    
    // MARK: - Button Action
    
    func showLoginViewController() {
        let loginViewController = UINavigationController(rootViewController: LoginViewController())
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    func showSignupViewController() {
        let signupViewController = SignupViewController()
        signupViewController.isPushLoad = false
        self.present(signupViewController, animated: true, completion: nil)
    }
    
    func logOut() {
        UserManager.shared.userLogOut()
        self.isUserLogonIn = false
    }
    
    func buttonTapped(_ sender: UIButton) {
        
    }
    
    // MARK: - Notifier Action
    
    func userDidGetUserInfo(notification: NSNotification) {
        profileView.userRealName = UserManager.shared.name
        isUserLogonIn = UserManager.shared.isLogIn
    }
    
    func userDidGetUserInfoFailure(notification: NSNotification) {
        self.noticeOnlyText("获取用户信息失败")
        profileView.userRealName = "未登录"
    }
    
    func userDidGetUserAvatar(notification: NSNotification) {
        profileView.avatarImageView.image = UserManager.shared.avatar
    }
    
    func userDidGetUserAvatarFailure(notification: NSNotification) {
        profileView.avatarImageView.image = #imageLiteral(resourceName: "left_icon_defaultAvatar")
    }
    
    // MARK: - TableView Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == data.count {
            // 最后一个section
            if isUserLogonIn {
                return loginData.count
            } else {
                return logoutData.count
            }
        }
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: LJ.leftMenuWidth, height: 20))
            let separatorLine = UIImageView(frame: CGRect(x: 0, y: 10, width: LJ.leftMenuWidth, height: 1))
            separatorLine.image = #imageLiteral(resourceName: "left_line")
            view.addSubview(separatorLine)
            return view
            
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: SlideMenuTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SlideMenuTableViewCell
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.isShowSeparatorLine = false
        cell.selectionStyle = .none
        
        let section = indexPath.section
        let row = indexPath.row
        
        var icon: UIImage
        var title: String
        
        if section == data.count {
            // 最后一个section
            if isUserLogonIn {
                (icon, title) = loginData[row]
            } else {
                (icon, title) = logoutData[row]
            }
        } else {
            (icon, title, _) = data[section][row]
        }
        
        cell.icon = icon
        cell.title = title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        
        if section == data.count {
            // 最后一个section
            if isUserLogonIn {
                logOut()
            } else {
                if row == 0 {
                    showLoginViewController()
                } else {
                    showSignupViewController()
                }
            }
        } else {
            let (_, _, vc) = data[section][row]
            self.slideMenuController()?.changeMainViewController(vc, close: true)
        }
        
    }
}

fileprivate extension Selector {
    static let tap = #selector(LeftViewController.buttonTapped(_:))
}
