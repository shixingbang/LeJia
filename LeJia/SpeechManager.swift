//
//  SpeechManager.swift
//  LeJia
//
//  Created by 王嘉宁 on 2017/6/11.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import Foundation
import Alamofire

public class SpeechManager: NSObject, Notifier, IFlySpeechSynthesizerDelegate {
    
    // MARK: - Properties
    
    /// 单例
    public static let shared: SpeechManager = SpeechManager()
    
    /// 语音合成
    lazy var speechSynthesizer: IFlySpeechSynthesizer = { [unowned self] in
        let s = IFlySpeechSynthesizer.sharedInstance()
        s?.setParameter("xiaoyu", forKey: IFlySpeechConstant.voice_NAME())
        s?.delegate = self
        return s!
    }()
    
    // 持有的 ViewController
    static var mainViewController: MainViewController!
    static var refuelNaviViewController: UINavigationController!
    static var refuelViewController: RefuelViewController!
    static var musicViewController: MusicViewController!
    static var carInfoNaviViewController: UINavigationController!
    static var carInfoViewController: CarInfoViewController!
    static var lifestyleNaviViewController: UINavigationController!
    static var lifestyleViewController: LifestyleViewController!
    
    static var leftViewController: LeftViewController!
    
    /// 当前参数
    static var currentArgument: String?
    /// 当前尾随闭包
    static var currentClosure: (() -> ())?
    
    fileprivate static let options = [
        
        // map & navi
        "showMain": {  SpeechManager.showMain() },
        "searchLocal": {  SpeechManager.searchLocal() },
        "searchPOI": {  SpeechManager.searchPOI() },
        "naviLocal": {  SpeechManager.naviLocal() },
        "naviPOI": {  SpeechManager.naviPOI() },
        
        // refuel
        "showRefuel": {  SpeechManager.showRefuel() },
        "speechOrder": {  SpeechManager.speechOrder() },
        "showOrder": {  SpeechManager.showOrder() },
        
        // music
        "showMusic": {  SpeechManager.showMusic() },
        "muiscPlay": {  SpeechManager.muiscPlay() },
        "muiscPlayChinese": {  SpeechManager.muiscPlayChinese() },
        "muiscPlayEnglish": {  SpeechManager.muiscPlayEnglish() },
        "muiscPause": {  SpeechManager.muiscPause() },
        "muiscPre": {  SpeechManager.muiscPre() },
        "muiscNext": {  SpeechManager.muiscNext() },
        
        // lifestyle
        "showLifestyle": {  SpeechManager.showLifestyle() },
        "askWhichCar&&speech?Info": {  SpeechManager.test() },
        "askWhichCar&&speech?Reason": {  SpeechManager.test() },
        
        // carInfo
        "showCarInfo": {  SpeechManager.showCarInfo() },
//        "askWhichCar": {  SpeechManager.askWhichCar() },
//        "speechCarInfo": {  SpeechManager.speechCarInfo() },
        
        // 天气
        "speechWeatherToday": {  SpeechManager.test() },
        "speechWeatherTomorrow": {  SpeechManager.test() },
        "speechWeatherAfterTomorrow": {  SpeechManager.test() },
        
        // 洗车
        "speechWashCarToday": {  SpeechManager.test() },
        "speechWashCarTomorrow": {  SpeechManager.test() },
        "speechWashCarAfterTomorrow": {  SpeechManager.test() },
        
        // 限行
        "checkTR&&speechTRToday": {  SpeechManager.test() },
        "checkTR&&speechTRTomorrow": {  SpeechManager.test() },
        "罚钱": {  SpeechManager.test() },
        "规则": {  SpeechManager.test() },
        "限行规则": {  SpeechManager.test() }
    ]
    
    /// 是否是askWhichCar
    static var isAskWhickCar = false
    
    /// 语音念完时推送通知
    /// 例如: 念"您的哪一辆车"结束后, 推送通知
    public enum Notification : String {
        case didSpeechComplete
    }
    
    // MARK: - Action
    
    func performAction(_ action: String, with argument: String?) {
        
        if let argument = argument {
            SpeechManager.currentArgument = argument
        }
        log(action)
        if action == "askWhichCar" {
            SpeechManager.isAskWhickCar = true
            askWhichCar()
            return
        }
        
        if action == "speechCarInfo" {
            speechCarInfo()
            return
        }
        
        if let actionClosure = SpeechManager.options[action] {
            actionClosure()
        }
        
    }
    
//    func performDepthAction(_ action: String, completionHandler: ([String]) -> ()) {
//        switch action {
//        case "askWhichCar":
//            if let carInfos = UserManager.shared.carInfos
//        default:
//            break
//        }
//    }
    
    static func test() {
        log("测试")
    }
    
    static func tttt() {
        
    }
    
    // MARK: - Map & Navi
    
    static func showMain() {
        leftViewController.slideMenuController()?.changeMainViewController(mainViewController, close: true)
    }
    
    static func searchLocal() {
        guard let keyword = currentArgument else { return }
        currentArgument = nil
        
        mainViewController.searchLocalAction(keywords: keyword)
    }
    
    static func searchPOI() {
        guard let keyword = currentArgument else { return }
        currentArgument = nil
        
        mainViewController.searchAroundAction(keywords: keyword)
    }
    
    static func naviLocal() {
        guard let keyword = currentArgument else { return }
        currentArgument = nil
        
        mainViewController.searchLocalAction(keywords: keyword)
        
    }
    
    static func naviPOI() {
        guard let keyword = currentArgument else { return }
        currentArgument = nil
        
        mainViewController.searchAroundAction(keywords: keyword)
        
    }
    
    // MARK: - Refuel
    
    static func showRefuel() {
        leftViewController.slideMenuController()?.changeMainViewController(refuelNaviViewController, close: true)
    }
    
    static func speechOrder() {
        
    }
    
    static func showOrder() {
        leftViewController.slideMenuController()?.changeMainViewController(refuelNaviViewController, close: true)
        refuelViewController.showOrderButtonTapped()
    }
    
    // MARK: - Music
    
    static func showMusic() {
        leftViewController.slideMenuController()?.changeMainViewController(musicViewController, close: true)
    }
    
    static func muiscPlay() {
        if musicViewController.didLoad {
            musicViewController.buttonTapped(sender: musicViewController.playButton)
        } else {
            showMusic()
        }
    }
    
    static func muiscPlayChinese() {
        muiscPlay()
    }
    
    static func muiscPlayEnglish() {
        muiscPlay()
    }
    
    static func muiscPause() {
        guard musicViewController.didLoad == true else { return }
        musicViewController.buttonTapped(sender: musicViewController.playButton)
    }
    
    static func muiscPre() {
        guard musicViewController.didLoad == true else { return }
        musicViewController.preButtonTapped()
        
    }
    
    static func muiscNext() {
        guard musicViewController.didLoad == true else { return }
        musicViewController.nextButtonTapped()
        
    }
    
    // MARK: - Lifestyle
    
    static func showLifestyle() {
        leftViewController.slideMenuController()?.changeMainViewController(lifestyleNaviViewController, close: true)
    }
    
    func askWhichCar() {
        guard let keyword = SpeechManager.currentArgument else { return }
        SpeechManager.currentArgument = nil
        log("speechSynthesizer speech: \(keyword)")
        speechSynthesizer.startSpeaking(keyword)
    }
    
    // MARK: - CarInfo
    
    static func showCarInfo() {
        leftViewController.slideMenuController()?.changeMainViewController(carInfoNaviViewController, close: true)
        
    }
    
    func speechCarInfo() {
        guard let keyword = SpeechManager.currentArgument else { return }
        SpeechManager.currentArgument = nil
        
        let carInfos = UserManager.shared.carInfos!
        for carInfo in carInfos {
            let carName = carInfo.brand + carInfo.model
            if carName == keyword {
                let text = "您的\(keyword), 已行驶\(carInfo.distance)公里, 发动机性能\(carInfo.motorStatus), 变速器性能\(carInfo.transStatus), 车灯性能\(carInfo.lightStatus)"
                speechSynthesizer.startSpeaking(text)
            }
        }
    }
    
    // MARK: - 天气
    
    
    // MARK: - IFlySpeechSynthesizerDelegate
    
    public func onCompleted(_ error: IFlySpeechError!) {
        log(error)
        
        if SpeechManager.isAskWhickCar {
            SpeechManager.postNotification(.didSpeechComplete)
            SpeechManager.isAskWhickCar = false
        }
    }
    
}





