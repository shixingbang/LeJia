//
//  SpeechUnderstander.swift
//  LeJia
//
//  Created by 王嘉宁 on 2017/6/11.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import Foundation
import Alamofire

/// 是否显示理解过程冗杂信息, 方便语义理解Debug
let showRedundantInfomation = false

func printR<T>(_ message: T) {
    if showRedundantInfomation {
        print(message)
    }
}

public class SpeechUnderstander: NSObject {
    
    // MARK: - Properties
    
    /// 单例
    public static let shared: SpeechUnderstander = SpeechUnderstander()
    
    /// 结构化语音指令
    lazy var instructionJSON: JSON! = {
        if let fileURL = Bundle.main.url(forResource: "StructuredKeywords", withExtension: "json") {
            do {
                let jsonData = try NSData(contentsOf: fileURL, options: NSData.ReadingOptions.mappedIfSafe)
                return JSON(jsonData)
            } catch {
                log("impossible", .error)
            }
        } else {
            print("tan 90")
        }
        return nil
    }()
    
    /// 上次识别具有深度值
    var lastRecognizeIsDepth = false
    /// 上次操作
    var lastAction = ""
    /// 描述
    var actionDescription = ""
    /// 深度
    var actionDepth = 0
    
    
    // MARK: - Action
    
    /// 理解一个分完词的句子
    /// - parameter rawText: 句子的分词数组
    /// - returns: (是否成功理解, 深度信息, 方法名, [参数], 描述)
    func recognize(with rawText: [String]) -> (Bool, Int, String, [String], String){
        
        var text = rawText
        var action = ""
        var arguments = [String]()
        
        //深度信息
        if lastRecognizeIsDepth == true {
            
            var argument = ""
            text.forEach {
                argument += $0.uppercased()
            }
            
            lastRecognizeIsDepth = false
            let action = lastAction
            lastAction = ""
            let tmpDescription = description
            actionDescription = ""
            actionDepth -= 1
            return (true, actionDepth, action, [argument], tmpDescription)
        }
        
        // 原始指令
        var rawIns = ""
        rawText.forEach {
            rawIns += $0
        }
        
        // 进行粗处理
        let roughWords = instructionJSON["roughHandlingWords"].array!
        for jsonRoughWord in roughWords {
            let word = jsonRoughWord["word"].string
            text = text.filter() { $0 != word }
        }
        
        print("---- ** SpeechManager ** ----")
        print("---- ** 开始理解 ** ----")
        print("---- ** 原始指令: \(rawIns) ** ----")
        print("---- ** 分词指令: \(rawText) ** ----")
        print("---- ** 粗处理指令: \(text) ** ----")
        
        func findAction(with instructions: [JSON]) -> Bool {
            for (index, instruction) in instructions.enumerated() {
                printR("")
                let words = instruction["words"].array!
                let level = instruction["level"].int!
                printR("- 当前层级为: \(level) 层 -")
                printR(" - 当前区块为: \(index + 1) 区 -")
                
                // 该区是否匹配到关键词
                var isMatched = false
                
                for (index, word) in words.enumerated() {
                    let keyword = word["word"].string!
                    printR(" \(index + 1). 关键词为: \(keyword)")
                    printR("   正在查找是否包含关键词: \(keyword)...")
                    
                    for userWord in text {
                        if userWord == keyword {
                            printR("   匹配到关键词: \(keyword)!!!")
                            // 删除该关键词
                            text = text.filter() { $0 != keyword }
                            isMatched = true
                        }
                    }
                }
                
                if isMatched {
                    // 是否有子层
                    let haveSublevel = instruction["have_sublevel"].bool
                    if haveSublevel! {
                        printR("有子层")
                        let subinstructions = instruction["sublevel"].array!
                        let isFindActionFromSubLevel = findAction(with: subinstructions)
                        if isFindActionFromSubLevel {
                            printR("子层发现并已经执行了操作")
                            return true
                        } else {
                            printR("子层没有可执行操作")
                        }
                    } else {
                        printR("没有子层")
                    }
                    let canActionNow = instruction["can_action_now"].bool
                    if canActionNow! {
                        
                        let argumentCount = instruction["now_action_arguments"].int!
                        if argumentCount > 0 {
                            // 保证至少有一个参数
                            guard text.count > 0 else { return false }
                            var argument = ""
                            text.forEach {
                                argument += $0
                            }
                            arguments.append(argument)
                        }
                        
                        let actionName = instruction["action"].string!
                        action = actionName
                        
                        if let depth = instruction["semantic_depth"].int {
                            lastRecognizeIsDepth = true
                            actionDescription = instruction["description"].string!
                            lastAction = action
                            actionDepth = depth
                        }
                        
                        printR("********************************")
                        printR("* 该层可以执行操作")
                        printR("* 用户原始指令:  \(rawIns)")
                        printR("* 操作方法名称:  \(actionName)")
                        printR("* 操作参数个数:  \(argumentCount)")
                        printR("* 操作参数名称:  \(arguments)")
                        printR("* 该层已经执行操作")
                        printR("********************************")
                        return true
                    } else {
                        printR("* 该层不可以执行操作")
                        return false
                    }
                }
                
                printR(" - \(index + 1) 区结束 -")
                
                printR("没有找到匹配的关键词!!")
                printR("-- \(level) 层结束 --")
            }
            return false
        }
        printR("")
        
        let instructions = instructionJSON["instructions"].array!
        let isFindAction = findAction(with: instructions)
        
        return (isFindAction, actionDepth, action, arguments, actionDescription)
        
    }
    
    /// 理解一个分完词的句子(第一版算法已抛弃, 无粗处理和深度信息)
    /// - parameter rawText: 句子的分词数组
    /// - returns: (是否成功理解, 深度信息, 方法名, [参数], 描述)
    func recognize2(with rawText: [String]) -> (Bool, Int, String, [String], String){
        
        var text = rawText
        var action = ""
        var arguments = [String]()
        
        // 原始指令
        var rawIns = ""
        rawText.forEach {
            rawIns += $0
        }

        print("---- ** SpeechManager ** ----")
        print("---- ** 开始理解 ** ----")
        print("---- ** 原始指令: \(rawIns) ** ----")
        print("---- ** 分词指令: \(rawText) ** ----")
        print("---- ** 粗处理指令: \(text) ** ----")
        
        func findAction(with instructions: [JSON]) -> Bool {
            for (index, instruction) in instructions.enumerated() {
                printR("")
                let words = instruction["words"].array!
                let level = instruction["level"].int!
                printR("- 当前层级为: \(level) 层 -")
                printR(" - 当前区块为: \(index + 1) 区 -")
                
                // 该区是否匹配到关键词
                var isMatched = false
                
                for (index, word) in words.enumerated() {
                    let keyword = word["word"].string!
                    printR(" \(index + 1). 关键词为: \(keyword)")
                    printR("   正在查找是否包含关键词: \(keyword)...")
                    
                    for userWord in text {
                        if userWord == keyword {
                            printR("   匹配到关键词: \(keyword)!!!")
                            // 删除该关键词
                            text = text.filter() { $0 != keyword }
                            isMatched = true
                        }
                    }
                }
                
                if isMatched {
                    // 是否有子层
                    let haveSublevel = instruction["have_sublevel"].bool
                    if haveSublevel! {
                        printR("有子层")
                        let subinstructions = instruction["sublevel"].array!
                        let isFindActionFromSubLevel = findAction(with: subinstructions)
                        if isFindActionFromSubLevel {
                            printR("子层发现并已经执行了操作")
                            return true
                        } else {
                            printR("子层没有可执行操作")
                        }
                    } else {
                        printR("没有子层")
                    }
                    let canActionNow = instruction["can_action_now"].bool
                    if canActionNow! {
                        
                        let argumentCount = instruction["now_action_arguments"].int!
                        if argumentCount > 0 {
                            // 保证至少有一个参数
                            guard text.count > 0 else { return false }
                            var argument = ""
                            text.forEach {
                                argument += $0
                            }
                            arguments.append(argument)
                        }
                        
                        let actionName = instruction["action"].string!
                        action = actionName
                        
                        if let depth = instruction["semantic_depth"].int {
                            lastRecognizeIsDepth = true
                            actionDescription = instruction["description"].string!
                            lastAction = action
                            actionDepth = depth
                        }
                        
                        printR("********************************")
                        printR("* 该层可以执行操作")
                        printR("* 用户原始指令:  \(rawIns)")
                        printR("* 操作方法名称:  \(actionName)")
                        printR("* 操作参数个数:  \(argumentCount)")
                        printR("* 操作参数名称:  \(arguments)")
                        printR("* 该层已经执行操作")
                        printR("********************************")
                        return true
                    } else {
                        printR("* 该层不可以执行操作")
                        return false
                    }
                }
                
                printR(" - \(index + 1) 区结束 -")
                
                printR("没有找到匹配的关键词!!")
                printR("-- \(level) 层结束 --")
            }
            return false
        }
        printR("")
        
        let instructions = instructionJSON["instructions"].array!
        let isFindAction = findAction(with: instructions)
        
        return (isFindAction, actionDepth, action, arguments, actionDescription)
        
    }
}

