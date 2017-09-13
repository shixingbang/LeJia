//
//  OrderInfo.swift
//  乐驾
//
//  Created by 王嘉宁 on 16/5/2.
//  Copyright © 2016年 Jianing. All rights reserved.
//

import Foundation



class OrderInfo: NSObject {
    
    /** 加油站名称*/
    var gasStation: String
    /** 加油站地点*/
    var address: String
    /** 汽油名称*/
    var gasName: String
    /** 汽油单价*/
    var gasPrice: String
    /** 订单金额*/
    var orderMoney: String
    /** 订单编号*/
    var no: String?
    /** 订单id*/
    var id: String?
    
    /** 查询订单信息*/
    init(gasStation: String, address: String, gasName: String, gasPrice: String, orderMoney: String, no: String, id: String) {
        self.gasStation = gasStation
        self.address = address
        self.gasName = gasName
        self.gasPrice = gasPrice
        self.orderMoney = orderMoney
        self.no = no
        self.id = id
    }
    
    /** 提交订单信息*/
    init(gasStation: String, address: String, gasName: String, gasPrice: String, orderMoney: String) {
        self.gasStation = gasStation
        self.address = address
        self.gasName = gasName
        self.gasPrice = gasPrice
        self.orderMoney = orderMoney
    }
}

