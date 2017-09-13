//
//  Log.swift
//  SecureLogon
//
//  Created by 王嘉宁 on 2017/4/20.
//  Copyright © 2017年 LeJia. All rights reserved.
//

import Foundation

enum LogType: String {
    case ln = "✏️"
    case error = "❗️"
    case date = "🕒"
    case url = "🌏"
    case json = "💡"
    case fuck = "🖕"
    case happy = "😄"
}

func log<T>(_ message: T,
            _ type: LogType = .ln,
            file: String = #file,
            method: String = #function,
            line: Int    = #line) {
    #if DEBUG
        print("\(type.rawValue) \((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}


