//
//  UserManager.swift
//  LeJia
//
//  Created by 王嘉宁 on 2017/5/23.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import Foundation
import Alamofire

public class UserManager: Notifier {
    
    public static let shared: UserManager = UserManager()
    
    fileprivate let userDefaults = UserDefaults.standard
    
    // MARK: - 用户相关
    
    var isLogIn = false
    
    /** 账号*/
    private var username = ""
    /** 密码*/
    private var password = ""
    /** token*/
    private var token = ""
    /** 昵称*/
    var name = ""
    /** 邮箱*/
    var mail = ""
    /** 头像*/
    var avatar: UIImage?
    
    /** 车辆信息*/
    var carInfos: [CarInfo]?
    /** 订单信息*/
    var orderInfos: [OrderInfo]?
    
    /// 是否需要念出来
    var isNeedSpeech = false
    
    public enum Notification : String {
        case didGetMessage
        case didGetMessageFailure
        case didSignup
        case didSignupFailure
        case didLogin
        case didLoginFailure
//        case didLogout
//        case didLogoutFailure
        case didGetUserInfo
        case didGetUserInfoFailure
        case didGetUserAvatar
        case didGetUserAvatarFailure
        case didGetCarInfo
        case didGetCarInfoFailure
        case didGetOrderInfo
        case didGetOrderInfoFailure
    }
    
    private enum Action {
        case getMessage
        case signUp
        case logIn
        case getUserInfo
        case getAvatar
        case getCarInfo
        case getOrderInfo
    }
    
    private let actionDict: [Action: (Notification, Notification)] =
        [.getMessage: (.didGetMessage, .didGetMessageFailure),
         .signUp: (.didSignup, .didSignupFailure),
         .logIn: (.didLogin, .didLoginFailure),
         .getUserInfo: (.didGetUserInfo, .didGetUserInfoFailure),
         .getAvatar: (.didGetUserAvatar, .didGetUserAvatarFailure),
         .getCarInfo: (.didGetCarInfo, .didGetCarInfoFailure),
         .getOrderInfo: (.didGetOrderInfo, .didGetOrderInfoFailure)]
    
    private func handleResult(_ action: Action, _ response: DataResponse<Any>, completionHandler: (JSON) -> ()) {
        switch response.result {
        case .success:
            guard let value = response.result.value else {
                log("response.result.value is nil", .error)
                return
            }
            let json = JSON(value)
            guard let status = json["code"].int else { return }
            guard status == 0 else {
                log(json, .error)
                
                let (_, failureNoti) = actionDict[action]!
                UserManager.postNotification(failureNoti)
                
                return
            }
            let (successNoti, _) = actionDict[action]!
            completionHandler(json)
            UserManager.postNotification(successNoti)
            return
        case .failure(let error):
            log(error, .error)
            let (_, failureNoti) = actionDict[action]!
            UserManager.postNotification(failureNoti)
            return
        }
    }

    func getMessage(_ phone: String) {
        log("send message to \(phone)", .json)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            UserManager.postNotification(.didGetMessage)
        })
    }
    
    func signup(username: String, password: String, name: String, email: String, photo: String) {
        Alamofire.request(Router.signUp(username, password, name, email, photo)).responseJSON { response in
            self.handleResult(.signUp, response, completionHandler: { (json) in
                log(json, .json)
            })
        }
    }
    
    func login(username: String, password: String) {
        Alamofire.request(Router.logIn(username, password)).responseJSON { response in
            self.handleResult(.logIn, response, completionHandler: { (json) in
                log(json, .json)
                
                self.token = json["result"].string!
                log(self.token, .json)
                
                self.isLogIn = true
                self.getUserInfo(token: self.token)
                // 用 Kingfisher (目前 token 永久有效)
                self.getUserAvatar(token: self.token)
                
                self.username = username
                self.password = password
                
                self.userDefaults.set(true, forKey: "didLogInLastTIme")
                self.userDefaults.set(self.username, forKey: "username")
                self.userDefaults.set(self.password, forKey: "password")
                self.userDefaults.synchronize()
            })
        }
    }
    
    func getUserInfo(token: String) {
        Alamofire.request(Router.getUserInfo(token)).responseJSON { response in
            self.handleResult(.getUserInfo, response, completionHandler: { (json) in
                log(json, .json)
                self.mail = json["result"]["email"].string!
                self.name = json["result"]["realname"].string!
                
            })
        }
    }
    
    func getUserAvatar(token: String) {
        Alamofire.request(Router.getUserAvatar(token)).responseImage { response in
            log(response, .url)
            guard let image = response.result.value as? UIImage else {
                log("convert to image failure", .error)
                log(response, .error)
                self.avatar = UIImage(named: "left_icon_defaultAvatar")
                UserManager.postNotification(.didGetUserAvatarFailure)
                return
            }
            self.avatar = image
            UserManager.postNotification(.didGetUserAvatar)
        }
    }
    
    func getUserCarInfo() {
        Alamofire.request(Router.getCarInfo(self.token)).responseJSON { response in
            self.handleResult(.getCarInfo, response, completionHandler: { (json) in
                
                var tempCarInfos = [CarInfo]()
                
                let carInfoResult = json["result"]
                let carInfoResultSize = carInfoResult.count
                
                for i in 0 ..< carInfoResultSize {
                    
                    let brand = carInfoResult[i]["brand"].string!
                    let model = carInfoResult[i]["model"].string!
                    let plateNumber = carInfoResult[i]["car_no"].string!
                    let archNumber = carInfoResult[i]["arch_no"].string!
                    let motorNumber = carInfoResult[i]["motor_no"].string!
                    let distance = carInfoResult[i]["distance"].string!
                    let leftOilVolume = carInfoResult[i]["left_oil"].string!
                    let motorStatus = carInfoResult[i]["motor_status"].string!
                    let transStatus = carInfoResult[i]["trans_status"].string!
                    let lightStatus = carInfoResult[i]["light_status"].string!
                    
                    let carInfo = CarInfo.init(brand: brand, model: model, plateNumber: plateNumber, archNumber: archNumber, motorNumber: motorNumber, distance: distance, leftOilVolume: leftOilVolume, motorStatus: motorStatus, transStatus: transStatus, lightStatus: lightStatus)
                    
                    tempCarInfos.append(carInfo)
                }
                self.carInfos = tempCarInfos
            })
        }
    }

    func getUserOrderInfo() {
        Alamofire.request(Router.getOrder(UserManager.shared.getToken())).responseJSON {
            response in
            self.handleResult(.getOrderInfo, response, completionHandler: {
                json in
                log(json, .json)
                
                guard let status = json["code"].int else { return }
                guard status == 0 else {
                    log(json, .error)
                    return
                }
                
                var tempOrderInfos = [OrderInfo]()
                
                let orderInfoResult = json["result"]
                let orderInfoResultSize = orderInfoResult.count
                
                for i in 0 ..< orderInfoResultSize {
                    print(orderInfoResult[i])
                    let no = orderInfoResult[i]["no"].string!
                    let cost = orderInfoResult[i]["cost"].string!
                    //                        let if_done = orderInfoResult[i]["if_done"].string!
                    let id = orderInfoResult[i]["id"].int!
                    let address = orderInfoResult[i]["address"].string!
                    let oil_station = orderInfoResult[i]["oil_station"].string!
                    let price = orderInfoResult[i]["price"].string!
                    let oil_type = orderInfoResult[i]["oil_type"].string!
                    
                    let orderInfo = OrderInfo.init(gasStation: oil_station, address: address, gasName: oil_type, gasPrice: price, orderMoney: cost, no: no, id: String.init(id))
                    tempOrderInfos.append(orderInfo)
                }
                self.orderInfos = tempOrderInfos
                
            })
        }
    }
    
    func userLogOut(){
        
        isLogIn = false
        
        username = ""
        password = ""
        token = ""
        name = ""
        mail = ""
        avatar = nil
        carInfos = []
        
        // 设置上次登录信息
        userDefaults.set(false, forKey: "didLogInLastTIme")
        userDefaults.set("", forKey: "username")
        userDefaults.set("", forKey: "password")
        userDefaults.synchronize()

    }
    
    func getToken() -> String {
        return self.token
    }
    
    func logInWithLastTimeInfo() {
        if userDefaults.bool(forKey: "didLogInLastTIme") {
            let username = userDefaults.string(forKey: "username")
            let password = userDefaults.string(forKey: "password")
            log(username, .happy)
            log(password, .happy)
            self.login(username: username!, password: password!)
        }
    }
    
    
}
