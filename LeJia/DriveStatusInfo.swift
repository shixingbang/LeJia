//
//  DriveStatusInfo.swift
//  乐驾
//
//  Created by 王嘉宁 on 16/5/20.
//  Copyright © 2016年 Jianing. All rights reserved.
//

import Foundation

class DriveStatusInfo: NSObject {
    
    var id: String!
    var info: String!
    var fen: String!
    var money: String!
    var officer: String!
    var occur_date: String!
    var occur_area: String!
    var city_name: String!
    var status: String!
    
    init(id: String, info: String, fen: String, money: String, officer: String, occur_date: String, occur_area: String, city_name: String, status: String) {
        self.id = id
        self.info = info
        self.fen = fen
        self.money = money
        self.officer = officer
        self.occur_date = occur_date
        self.occur_area = occur_area
        self.city_name = city_name
        self.status = status
    }
}