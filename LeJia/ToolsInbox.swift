//
//  ToolsInbox.swift
//  LeJia
//
//  Created by 王嘉宁 on 2017/5/26.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import Foundation


// 暂时不用了, 想要用路径加载图片, 必须在bundle里, 而不是assets
/**
 返回图片路径
 - parameter imageName: 图片名字
 - note: 默认添加 ".png" 后缀
 - returns: 强制解包的path
 */
//func getImagePath(with imageName: String) -> String {
//    let image = imageName
//    let path = Bundle.main.path(forResource: image, ofType: nil)
//    return path!
//}


/**
 简洁创建CGRect
 */
func Rect(_ x: Int, _ y: Int, _ width: Int, _ height: Int) -> CGRect{
    return CGRect(x: x, y: y, width: width, height: height)
}

func Rect(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect{
    return CGRect(x: x, y: y, width: width, height: height)
}

func Rect(_ x: Double, _ y: Double, _ width: Double, _ height: Double) -> CGRect{
    return CGRect(x: x, y: y, width: width, height: height)
}

/**
 检测邮箱是否合法
 - parameter email: 被检测的字符串
 - returns: Bool 是否合法
 */
func isValidEmail(_ email: String?) -> Bool {
    
    guard let email = email else { return false }
    
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    
    return emailTest.evaluate(with: email)
}

/**
 检测手机号是否合法
 - parameter phone: 被检测的字符串
 - returns: Bool 是否合法
 */
func isValidPhone(_ phone: String?) -> Bool {
    
    guard let phone = phone else { return false }
    
    let regEx = "^1(3|4|5|7|8)\\d{9}$"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", regEx)
    
    return emailTest.evaluate(with: phone)
}

/**
 检测短信验证码是否合法
 - parameter message: 被检测的字符串
 - note: 合法性: 6位纯数字
 - returns: Bool 是否合法
 */
func isValidMessageCode(_ message: String?) -> Bool {
    
    guard let message = message else { return false }
    
    let regEx = "^\\d{6}$"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", regEx)
    
    return emailTest.evaluate(with: message)
}

/**
 检测密码是否合法
 - parameter message: 被检测的字符串
 - note: 合法性: 长度大于6位
 - returns: Bool 是否合法
 */
func isValidPassword(_ password: String?) -> Bool {
    
    guard let password = password else { return false }
    
    guard password.characters.count >= 6 else { return false }
    
    return true
}

