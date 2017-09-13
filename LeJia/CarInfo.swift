//
//  CarInfo.swift
//  乐驾
//
//  Created by 王嘉宁 on 16/5/6.
//  Copyright © 2016年 Jianing. All rights reserved.
//

import Foundation

class CarInfo: NSObject {
    
    /** id*/
    var id: String?
    /** 品牌*/
    var brand: String
    /** 型号*/
    var model: String
    /** 车牌号*/
    var plateNumber: String
    /** 车架号*/
    var archNumber: String
    /** 发动机号*/
    var motorNumber: String
    /** 里程数*/
    var distance: String
    /** 剩余油量*/
    var leftOilVolume: String
    /** 发动机性能*/
    var motorStatus: String
    /** 变速器性能*/
    var transStatus: String
    /** 车灯性能*/
    var lightStatus: String
    
    /** 查询车辆信息*/
    init(id: String, brand: String, model: String, plateNumber: String, archNumber: String, motorNumber: String, distance: String, leftOilVolume: String, motorStatus: String, transStatus: String, lightStatus: String) {
        self.id = id
        self.brand = brand
        self.model = model
        self.plateNumber = plateNumber
        self.archNumber = archNumber
        self.motorNumber = motorNumber
        self.distance = distance
        self.leftOilVolume = leftOilVolume
        self.motorStatus = motorStatus
        self.transStatus = transStatus
        self.lightStatus = lightStatus
    }
    
    /** 添加车辆信息*/
    init(brand: String, model: String, plateNumber: String, archNumber: String, motorNumber: String, distance: String, leftOilVolume: String, motorStatus: String, transStatus: String, lightStatus: String) {
        self.brand = brand
        self.model = model
        self.plateNumber = plateNumber
        self.archNumber = archNumber
        self.motorNumber = motorNumber
        self.distance = distance
        self.leftOilVolume = leftOilVolume
        self.motorStatus = motorStatus
        self.transStatus = transStatus
        self.lightStatus = lightStatus
    }
    
    func getDiscription() -> String {
        return "\(self.brand) \(self.model),车牌：\(self.plateNumber),车架号：\(self.archNumber),发动机型号：\(self.motorNumber),里程数：\(self.distance),剩余油量：\(self.leftOilVolume)%,发动机性能：\(self.motorStatus),变速器性能：\(self.transStatus),车灯性能：\(self.lightStatus)"
    }
}
