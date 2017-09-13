//
//  GasStationInfo.swift
//  乐驾
//
//  Created by 王嘉宁 on 16/4/25.
//  Copyright © 2016年 Jianing. All rights reserved.
//

import Foundation

class GasStationInfo: NSObject {
    
    var name: String
    var address: String
    
    var brandname: String
    var type: String
    var discount: String
    
    var price: [GasPriceInfo]
    
    init(name: String, address: String, brandname: String, type: String, discount: String, price: [GasPriceInfo]) {
        self.name = name
        self.address = address
        
        self.brandname = brandname
        self.type = type
        self.discount = discount
        
        self.price = price
    }
}

class GasPriceInfo: NSObject {
    var name: String
    var price: String
    init(name: String, price: String) {
        self.name = name
        self.price = price
    }
}
