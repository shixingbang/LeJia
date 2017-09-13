//
//  Router.swift
//  LeJia
//
//  Created by 王嘉宁 on 2017/5/13.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

enum Router: URLRequestConvertible {
    
    static let baseURLString = "http://139.199.38.207:8000"
    
    // MARK: - 用户模块
    
    /** 注册*/
    case signUp(String, String, String, String, String)
    /** 登录*/
    case logIn(String, String)
    /** 获取用户信息*/
    case getUserInfo(String)
    /** 获取用户头像*/
    case getUserAvatar(String)
    
    // MARK: - 车辆信息管理
    
    /** 添加车辆信息*/
    case addCarInfo(String, CarInfo)
    /** 获取车辆信息*/
    case getCarInfo(String)
    /** 修改车辆信息*/
    case modifyCarInfo(String, String, String, String, String, String, String, String, String, String, String, String)
    /** 获取车标*/
    case getBrandLogo(String)
    /** 检查车辆信息*/
    case checkCarInfo(String)
    
    // MARK: - 预约加油模块
    
    /** 获取加油站数据, 临时代替!*/
    case getRefuelInfo()
    /** 提交订单*/
    case commitOrder(String, OrderInfo)
    /** 获取订单*/
    case getOrder(String)
    /** 获取订单二维码*/
    case getOrderQRCode(String, String)
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .signUp:
            return .post
        case .logIn:
            return .post
        case .getUserInfo:
            return .get
        case .getUserAvatar:
            return .get
            
        case .addCarInfo:
            return .post
        case .getCarInfo:
            return .get
        case .modifyCarInfo:
            return .put
        case .getBrandLogo:
            return .get
        case .checkCarInfo:
            return .get
            
        case .getRefuelInfo:
            return .get
        case .commitOrder:
            return .post
        case .getOrder:
            return .get
        case .getOrderQRCode:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "/user"
        case .logIn:
            return "/auth"
        case .getUserInfo:
            return "/user/i"
        case .getUserAvatar:
            return "/user/i/photo"
            
        case .addCarInfo:
            return "user/i/car"
        case .getCarInfo:
            return "user/i/car"
        case .modifyCarInfo(_, let id, _, _, _, _, _, _, _, _, _, _):
            return "/user/i/car/\(id)"
        case .getBrandLogo(let brand):
            return "/logo/\(brand)"
        case .checkCarInfo:
            return "/user/i/car/status"
            
        case .getRefuelInfo:
            return "/jh"
        case .commitOrder:
            return "/user/i/order"
        case .getOrder:
            return "/user/i/order"
        case .getOrderQRCode(_, let id):
            return "/user/i/order/\(id)/pic"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: Router.baseURLString)!
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
            
            
        case .signUp(let username, let password, let realname, let email, let photo):
            let params = ["username": username, "password": password, "realname": realname, "email": email, "photo": photo]
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: params)
        case .logIn(let username, let password):
            let params = ["username": username, "password": password]
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: params)
        case .getUserInfo(let api_token):
            let params = ["api_token": api_token]
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: params)
        case .getUserAvatar(let api_token):
            let params = ["api_token": api_token]
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: params)
            
            
        case .addCarInfo(let api_token, let carInfo):
            let params = ["api_token": api_token, "brand": carInfo.brand, "model": carInfo.model, "car_no" : carInfo.plateNumber, "arch_no" : carInfo.archNumber, "motor_no" : carInfo.motorNumber, "distance" : carInfo.distance, "left_oil" : carInfo.leftOilVolume, "motor_status" : carInfo.motorStatus, "trans_status" : carInfo.transStatus, "light_status" : carInfo.lightStatus]
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: params )
        case .getCarInfo(let api_token):
            let params = ["api_token": api_token]
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: params)
        case .modifyCarInfo(let api_token, _, let brand, let model, let car_no, let arch_no, let motor_no, let distance, let left_oil, let motor_status, let trans_status, let light_status):
            let params = ["api_token": api_token, "brand": brand, "model": model, "car_no" : car_no, "arch_no" : arch_no, "motor_no" : motor_no, "distance" : distance, "left_oil" : left_oil, "motor_status" : motor_status, "trans_status" : trans_status, "light_status" : light_status]
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: params)
        case .getBrandLogo(_):
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: nil)
        case .checkCarInfo(let api_token):
            let params = ["api_token": api_token]
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: params)
            
        case .getRefuelInfo():
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: nil)
        case .commitOrder(let api_token, let orderInfo):
            let params = ["api_token": api_token, "oil_station": orderInfo.gasStation, "address": orderInfo.address, "oil_type": orderInfo.gasName, "price": orderInfo.gasPrice, "cost": orderInfo.orderMoney]
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: params)
        case .getOrder(let api_token):
            let params = ["api_token": api_token]
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: params)
        case .getOrderQRCode(let api_token, _):
            let params = ["api_token": api_token]
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: params)
        }
    }
}
