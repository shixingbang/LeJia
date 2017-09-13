//
//  SpeechSearchViewController.swift
//  LeJia
//
//  Created by 王嘉宁 on 2017/5/15.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import UIKit

class SpeechSearchViewController: UIViewController {
    
    // MARK: - Properties
    
    /// 关闭按钮
    @IBOutlet weak var closeButton: UIButton!
    
    /// 波浪动画视图
    @IBOutlet weak var waveView: SwiftSiriWaveformView!
    /// 波浪是否开始
    var isWaveAnimating = false
    /// wave定时器
    var waveTimer: Timer?
    /// 振幅波动大小
    var waveChangeValue:CGFloat = 0.01
    
    /// label定时器
    var labelTimer: Timer?
    
    /// 顶部欢迎标语
    @IBOutlet weak var topWelcomeLabel: UILabel!
    /// 识别结果
    @IBOutlet weak var resultLabel: UILabel!
    /// 大号提示
    @IBOutlet weak var hintLabel: UILabel!
    
    /// 循环标签一
    lazy var hintLabelOne: UILabel = {
        let l = UILabel(frame: Rect(0, 0, LJ.screenWidth, 25))
        l.textColor = .white
        l.textAlignment = .center
        l.alpha = 0
        return l
    }()
    /// 循环标签二
    lazy var hintLabelTwo: UILabel = {
        let l = UILabel(frame: Rect(0, 0, LJ.screenWidth, 25))
        l.textColor = .white
        l.textAlignment = .center
        l.alpha = 0
        return l
    }()
    /// 循环标签三
    lazy var hintLabelThree: UILabel = {
        let l = UILabel(frame: Rect(0, 0, LJ.screenWidth, 25))
        l.textColor = .white
        l.textAlignment = .center
        l.alpha = 0
        return l
    }()
    /// 循环标签四
    lazy var hintLabelFour: UILabel = {
        let l = UILabel(frame: Rect(0, 0, LJ.screenWidth, 25))
        l.textColor = .white
        l.textAlignment = .center
        l.alpha = 0
        return l
    }()
    
    lazy var hintLabels: [UILabel] = {
        return [self.hintLabelOne, self.hintLabelTwo, self.hintLabelThree, self.hintLabelFour]
    }()
    
    let hintLabelMoveValue: CGFloat = 300
    
    /// 语音识别
    var speechRecognizer: IFlySpeechRecognizer!
    /// 上传词库
    var dataUploader: IFlyDataUploader = IFlyDataUploader()
    
    /// 是否在监听
    var isListening = false
    
    /// 结果
    var result = ""
    /// 结果数组 (分完词的)
    var resultArray = [String]() {
        didSet {
            result = ""
            resultArray.forEach {
                result += $0
            }
            resultLabel.text = result
        }
    }
    
    fileprivate let hintArray =
        ["搜索附近的加油站",
         "我的车辆状态怎么样",
         "我的订单有哪些",
         "播放音乐",
         "打开车辆信息界面",
         "显示我的订单",
         "查找周围的酒店",
         "下一首"]
    
    fileprivate var hintIndex = 0
    
    fileprivate var tmpArray = [String]() {
        didSet {
            showHintLabelWithResult()
        }
    }
    
    var changeHingLabelToResult = false
    

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = LJ.blueDefault
        
        initUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        uploadUserWords()
        initRecognizer()
        if UserManager.shared.isLogIn {
            topWelcomeLabel.text = "你好, \(UserManager.shared.name)!"
            
            UserManager.shared.getUserCarInfo()
            UserManager.shared.getUserOrderInfo()
            
            
        } else {
            topWelcomeLabel.text = "你好, 欢迎使用乐驾!"
        }
        
        // 注册通知
        
        SpeechManager.addObserver(observer: self, selector: .speechComplete, notification: .didSpeechComplete)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showDefaultHintLabel()
        
        hintIndex = 0
        changeHintLabels()
        showHintLabels()
        startShowHintLabel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        speechRecognizer.cancel()
        speechRecognizer.delegate = nil
        speechRecognizer.setParameter("", forKey: IFlySpeechConstant.params())
        
        stopHintLabel()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        SpeechManager.removeObserver(observer: self, notification: .didSpeechComplete)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Init
    
    func initUI() {
        hintLabels.forEach {
            self.view.addSubview($0)
        }
        
        // 密度
        waveView.density = 1.0
        // 幅度
        waveView.amplitude = 0.0
    }
    
    func initRecognizer() {
        
        if speechRecognizer == nil {
            log("init speechRecognizer")
            speechRecognizer = IFlySpeechRecognizer.sharedInstance()
            speechRecognizer.setParameter("", forKey: IFlySpeechConstant.params())
            speechRecognizer.setParameter("iat", forKey: IFlySpeechConstant.ifly_DOMAIN())
            speechRecognizer.delegate = self
            
            // 设置最长录音时间
            speechRecognizer.setParameter("6000", forKey: IFlySpeechConstant.speech_TIMEOUT())
            // 设置网络等待时间
            speechRecognizer.setParameter("10000", forKey: IFlySpeechConstant.net_TIMEOUT())
            // 设置后端点
            speechRecognizer.setParameter("3000", forKey: IFlySpeechConstant.vad_EOS())
            // 设置前端点
            speechRecognizer.setParameter("3000", forKey: IFlySpeechConstant.vad_BOS())
            // 设置采样率, 推荐使用16K
            speechRecognizer.setParameter("16000", forKey: IFlySpeechConstant.sample_RATE())
            // 设置是否返回标点符号 0: 无标点 1: 有标点
            speechRecognizer.setParameter("0", forKey: IFlySpeechConstant.asr_PTT())
            // 设置语言
            speechRecognizer.setParameter("zh_cn", forKey: IFlySpeechConstant.language())
            // 设置方言 普通话
            speechRecognizer?.setParameter("mandarin", forKey: IFlySpeechConstant.accent())
        }
    }
    
    /// 上传用户词表
    func uploadUserWords() {
        dataUploader.setParameter("iat", forKey: IFlySpeechConstant.subject())
        dataUploader.setParameter("userword", forKey: IFlySpeechConstant.data_TYPE())
        
        let userWords = IFlyUserWords(json: LJ.userwords)
        dataUploader.uploadData(completionHandler: { (grammerID, error) in
            guard error?.errorCode == 0 else {
                log("上传用户词组失败", .error)
                
                return
            }
            log("上传用户词组成功")
        }, name: "userwords", data: userWords?.toString())
    }
    
    // MARK: - Manage Hint Label
    
    func startShowHintLabel() {
        labelTimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(SpeechSearchViewController.showHintLabels), userInfo: nil, repeats: true)
    }
    
    func stopHintLabel() {
        labelTimer?.invalidate()
        hintLabels.forEach {
            $0.layer.removeAllAnimations()
            $0.alpha = 0
        }
    }
    
    func changeHintLabels() {
        for label in hintLabels {
            label.text = hintArray[hintIndex]
            hintIndex += 1
            if hintIndex >= hintArray.count {
                hintIndex = 0
            }
        }
    }
    
    func showDefaultHintLabel() {
        self.hintLabel.text = "你可以这样问我:"
    }
    
    func showHintLabels() {
        
        var tmpIndex = 0
        hintLabels.forEach {
            $0.alpha = 0
            $0.center.y = 145 + hintLabelMoveValue + CGFloat(45 * tmpIndex)
            tmpIndex += 1
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.hintLabelOne.center.y -= self.hintLabelMoveValue
            self.hintLabelOne.alpha = 1
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseIn, animations: {
            self.hintLabelTwo.center.y -= self.hintLabelMoveValue
            self.hintLabelTwo.alpha = 1
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseIn, animations: {
            self.hintLabelThree.center.y -= self.hintLabelMoveValue
            self.hintLabelThree.alpha = 1
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseIn, animations: {
            self.hintLabelFour.center.y -= self.hintLabelMoveValue
            self.hintLabelFour.alpha = 1
        }, completion: nil)
        
        
        UIView.animate(withDuration: 0.5, delay: 3.0, options: .curveEaseOut, animations: {
            self.hintLabelOne.center.y -= self.hintLabelMoveValue
            self.hintLabelOne.alpha = 0
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 3.1, options: .curveEaseOut, animations: {
            self.hintLabelTwo.center.y -= self.hintLabelMoveValue
            self.hintLabelTwo.alpha = 0
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 3.2, options: .curveEaseOut, animations: {
            self.hintLabelThree.center.y -= self.hintLabelMoveValue
            self.hintLabelThree.alpha = 0
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 3.3, options: .curveEaseOut, animations: {
            self.hintLabelFour.center.y -= self.hintLabelMoveValue
            self.hintLabelFour.alpha = 0
        }, completion: { (true) in
            self.changeHintLabels()
        })
    }
    
    func showHintLabelWithResult() {
        
        for (index, label) in hintLabels.enumerated() {
//            label.layer.removeAllAnimations()
//            label.alpha = 0
            label.center.y = 145 + hintLabelMoveValue + CGFloat(45 * index)
            
            if index > tmpArray.count - 1 {
                label.text = ""
            } else {
                label.text = tmpArray[index]
                log(tmpArray[index], .fuck)
            }
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseIn, animations: {
            self.hintLabelOne.center.y -= self.hintLabelMoveValue
            self.hintLabelOne.alpha = 1
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.6, options: .curveEaseIn, animations: {
            self.hintLabelTwo.center.y -= self.hintLabelMoveValue
            self.hintLabelTwo.alpha = 1
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.7, options: .curveEaseIn, animations: {
            self.hintLabelThree.center.y -= self.hintLabelMoveValue
            self.hintLabelThree.alpha = 1
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.8, options: .curveEaseIn, animations: {
            self.hintLabelFour.center.y -= self.hintLabelMoveValue
            self.hintLabelFour.alpha = 1
        }, completion: nil)
    }
    
    // MARK: - Wave View Action
    
    /// 刷新 WaveView
    func refreshWaveView(_:Timer) {
        if self.waveView.amplitude <= self.waveView.idleAmplitude || self.waveView.amplitude > 1.0 {
            self.waveChangeValue *= -1.0
        }
        
        self.waveView.amplitude += self.waveChangeValue
        
        // 只有当不再监听, 并且曲线幅度小于0.02时, 算作动画停止
        if isListening == false && self.waveView.amplitude <= 0.02 {
            waveTimer?.invalidate()
            self.waveView.amplitude = 0
            isWaveAnimating = false
        }
    }
    
    /// 开始计时器
    func startWaveView() {
        isWaveAnimating = true
        waveTimer = Timer.scheduledTimer(timeInterval: 0.009, target: self, selector: #selector(SpeechSearchViewController.refreshWaveView(_:)), userInfo: nil, repeats: true)
    }
    
    /// 开始监听
    func startListen() {
        isListening = true
        resultLabel.text = ""
        result = ""
        resultArray.removeAll()
        speechRecognizer.cancel()
        speechRecognizer.setParameter("1", forKey: "audio_source")
        speechRecognizer.setParameter("json", forKey: IFlySpeechConstant.result_TYPE())
        if speechRecognizer.startListening() {
            log("开始监听")
            startWaveView()
        }
    }
    
    /// 停止监听
    func stopListen() {
        isListening = false
        speechRecognizer.cancel()
    }
    
    // MARK: - Button Action

    @IBAction func waveButtonTapped(_ sender: UIButton) {
        if isListening {
            stopListen()
        } else {
            // 如果动画没有结束, 直接返回
            guard isWaveAnimating == false else { return }
            startListen()
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension SpeechSearchViewController: IFlySpeechRecognizerDelegate{
    
    /// 语音识别过程回调
    func onResults(_ results: [Any]!, isLast: Bool) {
        
        guard results != nil else {
            log("nil?", .error)
            return
        }
        
        let dictionaryResult = results[0] as! NSDictionary
        for (rawStringJSONResult, _) in dictionaryResult {
            let stringJSONResult = rawStringJSONResult as? String
            var json: JSON!
            if let dataFromString = stringJSONResult?.data(using: .utf8, allowLossyConversion: false) {
                do {
                    json = try JSON(data: dataFromString)
                } catch {
                    log("Convert String to JSON Failure", .error)
                }
            }
            //log(json, .json)
            for jsonWord in json["ws"].array! {
                let stringWord = jsonWord["cw"][0]["w"].string
                guard stringWord != "" else { return }
                // 添加到结果数组
                resultArray.append(stringWord!)
            }
        }
    }
    
    /// 语音识别结束回调
    func onError(_ errorCode: IFlySpeechError!) {
        
        stopListen()
        
        guard errorCode.errorCode == 0 else {
            log("语音识别发生错误", .error)
            return
        }
        
        log("语音识别成功", .happy)
        log("开始理解")
        
        
        guard resultArray.count > 0 else { return }
        
        let (isRecogize, depth, action, arguments, description)
            = SpeechUnderstander.shared.recognize(with: resultArray)
        
        if isRecogize {
            
            print()
            print("********************************")
            print("* 理解成功 😄")
            print("* 指令:     \(resultArray)")
            print("* 深度:     \(depth)")
            print("* 方法:     \(action)")
            print("* 参数:     \(arguments)")
            print("* 描述:     \(description)")
            print("********************************")
            print()
            
            let actionWithDepth = "askWhichCar"
            
            if depth == 0 {
                // 不具有深度信息
                if arguments.count > 0 {
                    SpeechManager.shared.performAction(action, with: arguments[0])
                } else {
                    SpeechManager.shared.performAction(action, with: nil)
                }
                self.dismiss(animated: true, completion: nil)
                
            } else {
                // 具有深度
                hintLabel.text = description
                SpeechManager.shared.performAction(actionWithDepth, with: description)
                guard let carInfos = UserManager.shared.carInfos else {
                    log("didn't have car info", .error)
                    return
                }
                var carName = [String]()
                for carInfo in carInfos {
                    let name = carInfo.brand + carInfo.model
                    carName.append(name)
                }
                stopHintLabel()
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    self.tmpArray = carName
                })
                
            }
            
            
        } else {
            
            print()
            print("********************************")
            print("* 理解失败 😡")
            print("* 指令:     \(resultArray)")
            print("* 描述:     \(description)")
            print("********************************")
            print()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.resultLabel.text = "很抱歉, 没有理解您的意思"
            })
        }
    }
    
    func onBeginOfSpeech() {
        log("Speech Begin")
    }
    
    func onEndOfSpeech() {
        log("Speech End")
    }
    
    // MARK: - Notification
    
    func didSpeechComplete() {
        self.startListen()
    }
    
}

fileprivate extension Selector {
    static let speechComplete = #selector(SpeechSearchViewController.didSpeechComplete)
    
}





