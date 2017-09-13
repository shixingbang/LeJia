//
//  ProvinceInfo.swift
//  乐驾
//
//  Created by 王嘉宁 on 16/5/19.
//  Copyright © 2016年 Jianing. All rights reserved.
//

import Foundation

class ProvinceInfo: NSObject {
    
    var id: String!
    var name: String!
    var short_name: String!
    
    var citys: [CityInfo]!
    
    init(id: String, name: String, short_name: String, citys: [CityInfo]) {
        self.id = id
        self.name = name
        self.short_name = short_name
        self.citys = citys
    }
}

class CityInfo: NSObject {
    
    var id: String!
    var name: String!
    var car_head: String!
    var engineno: String!
    var classno: String!
    var registno: String!
    
    init(id: String, name: String, car_head: String, engineno: String, classno: String, registno: String) {
        self.id = id
        self.name = name
        self.car_head = car_head
        self.engineno = engineno
        self.classno = classno
        self.registno = registno
    }
    
}

class ProvinceCityInfo: NSObject {
    var id: String!
    var city: String!
    var province: String!
    var provinceCity: String!
    
    var section: Int?
    
    init(id: String, city: String, province: String, provinceCity: String) {
        self.id = id
        self.city = city
        self.province = province
        self.provinceCity = provinceCity
    }
}

// custom type to represent table sections

class Section {
    
    var items: [ProvinceCityInfo] = []
    
    func addItem(item: ProvinceCityInfo) {
        self.items.append(item)
    }
    
}

