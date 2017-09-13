//
//  Selector+SecureLogon.swift
//  SecureLogon
//
//  Created by 王嘉宁 on 2017/4/21.
//  Copyright © 2017年 SDCA. All rights reserved.
//

import Foundation

extension Selector {
    
    // Notifier Action
    static let userDidGetMsg = #selector(SignupViewController.userDidGetMsg(notification:))
    static let userDidGetMsgFailure = #selector(SignupViewController.userDidGetMsgFailure(notification:))
    static let userDidSignup = #selector(SignupViewController.userDidSignup(notification:))
    static let userDidSignupFailure = #selector(SignupViewController.userDidSignupFailure(notification:))
    static let userDidLogin = #selector(LoginViewController.userDidLogin(notification:))
    static let userDidLoginFailure = #selector(LoginViewController.userDidLoginFailure(notification:))

    
    static let userDidGetUserInfo = #selector(LeftViewController.userDidGetUserInfo(notification:))
    static let userDidGetUserInfoFailure = #selector(LeftViewController.userDidGetUserInfoFailure(notification:))
    static let userDidGetUserAvatar = #selector(LeftViewController.userDidGetUserAvatar(notification:))
    static let userDidGetUserAvatarFailure = #selector(LeftViewController.userDidGetUserAvatarFailure(notification:))
    
    static let userDidGetCarInfo = #selector(CarInfoViewController.userDidGetCarInfo(notification:))
    static let userDidGetCarInfoFailure = #selector(CarInfoViewController.userDidGetCarInfoFailure(notification:))

    static let userDidGetOrderInfo = #selector(MyOrderTableViewController.userDidGetOrderInfo(notification:))
    static let userDidGetOrderInfoFailure = #selector(MyOrderTableViewController.userDidGetOrderInfoFailure(notification:))
    
    static let userDidGetViolationCarInfo = #selector(LifestyleViewController.userDidGetCarInfo(notification:))
    static let userDidGetViolationCarInfoFailure = #selector(LifestyleViewController.userDidGetCarInfoFailure(notification:))
    
    
    // Button Action
    // 为了避免重名, 每个文件的 button action 
    // 放在该文件的 fileprivate extension 中
    
}
