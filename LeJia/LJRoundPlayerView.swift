//
//  LJRoundPlayerView.swift
//  LeJia
//
//  Created by SXB on 2017/5/17.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import UIKit

protocol LJRoundPlayerViewDelegate {
    func controlButtonTapped(index: Int, state: String)
}

class LJRoundPlayerView: UIView {

    // MARK: - Properties
    
    var delegate: LJRoundPlayerViewDelegate?
    
    var coverImageView: UIImageView!
    var timeLabel: UILabel!
    var actionOne: LJPlayButton!
    var actionTwo: LJPlayButton!
    var actionThree: LJPlayButton!
    
    /// duration of song
    var progress : Double = 0.0
    
    /// is music playing
    var isPlaying : Bool = false
    
    /// set progress colors
    var progressEmptyColor : UIColor = UIColor.white
    var progressFullColor : UIColor = UIColor.red
    
    /* Timer for update time*/
    private var timer: Timer!
    
    /* Controlling progress bar animation with isAnimating */
    private var isAnimating : Bool = false
    
    /* increasing duration in updateTime */
    private var duration : Double{
        didSet{
            redrawStrokeEnd()
        }
    }
    
    private var circleLayer: CAShapeLayer! = CAShapeLayer()
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        
        self.duration = 0
        super.init(frame: frame)
    
        self.createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // fatalError("init(coder:) has not been implemented")
        self.duration = 0
        super.init(coder: aDecoder)
        
        self.createUI()
    }
    
    // MARK: - Override
    
    override func draw(_ rect: CGRect) {
        self.addCirle(arcRadius: self.bounds.width + 10, capRadius: 2.0, color: self.progressEmptyColor,strokeStart: 0.0,strokeEnd: 1.0)
        self.createProgressCircle()

    }
    
    func animationDidStart(anim: CAAnimation) {
        
        circleLayer.strokeColor = self.progressFullColor.cgColor
        self.isAnimating = true
        self.duration = 0
    }

    func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        
        self.isAnimating = false
        circleLayer.strokeColor = UIColor.clear.cgColor
        
        if(timer != nil) {
            timer.invalidate()
            timer = nil
        }
    }

    
    // MARK: - Init UI
    
    func createUI() {
        initCoverImage()
        initTimeLabel()
        initActionOne()
        initActionTwo()
        initActionThree()
        self.makeItRounded(view: coverImageView, newSize: self.bounds.width)
        self.backgroundColor = UIColor.clear

    }
    
    func buttonTapped(sender: LJPlayButton) {
        sender.onClick()
        switch sender.id() {
        case 1:
            if sender.isTapped {
                actionThree.setUnClick()
                delegate?.controlButtonTapped(index: 0, state: "tapped")
            }else{
                delegate?.controlButtonTapped(index: 0, state: "untapped")
            }
        case 2:
            if sender.isTapped {
                delegate?.controlButtonTapped(index: 1, state: "tapped")
            }else{
                delegate?.controlButtonTapped(index: 1, state: "untapped")
            }
        case 3:
            if sender.isTapped {
                actionOne.setUnClick()
                delegate?.controlButtonTapped(index: 2, state: "tapped")
            }else{
                delegate?.controlButtonTapped(index: 2, state: "untapped")
            }
        default:
            break
        }
    }
    
    private func initCoverImage() {
        
        coverImageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        coverImageView.backgroundColor = UIColor.clear
        self.addSubview(coverImageView)
    }
    
    private func initTimeLabel() {
        
        timeLabel = UILabel(frame: CGRect.init(x: 0, y: self.bounds.height/2 - 20, width: self.bounds.width, height: 40))
        timeLabel.font = UIFont(name: "Helvetica", size: 24)
        timeLabel.textColor = UIColor.white
        timeLabel.textAlignment = .center
        self.addSubview(timeLabel)
    }
    
    private func initActionOne() {
        actionOne = LJPlayButton(frame: CGRect.init(x: (self.bounds.width - 20) / 2 - 40, y: self.bounds.height / 2 + 30, width: 20, height: 20), id: 1, normalImage: UIImage(named: "music_btn_random")!, tappedImage: UIImage(named: "music_btn_random_selected")!)
        actionOne.addTarget(self, action: #selector(LJRoundPlayerView.buttonTapped(sender:)), for: UIControlEvents.touchUpInside)
        self.addSubview(actionOne)
    }
    
    private func initActionTwo() {
        actionTwo = LJPlayButton(frame: CGRect.init(x: (self.bounds.width - 20) / 2, y: self.bounds.height / 2 + 30, width: 20, height: 20), id: 2, normalImage: UIImage(named: "music_btn_like")!, tappedImage: UIImage(named: "music_btn_like_selected")!)
        actionTwo.addTarget(self, action: #selector(LJRoundPlayerView.buttonTapped(sender:)), for: UIControlEvents.touchUpInside)
        self.addSubview(actionTwo)
    }
    
    private func initActionThree() {
        actionThree = LJPlayButton(frame: CGRect.init(x: (self.bounds.width - 20) / 2 + 40, y: self.bounds.height / 2 + 30, width: 20, height: 20), id: 3, normalImage: UIImage(named: "music_btn_repeat")!, tappedImage: UIImage(named: "music_btn_repeat_selected")!)
        actionThree.addTarget(self, action: #selector(LJRoundPlayerView.buttonTapped(sender:)), for: UIControlEvents.touchUpInside)
        self.addSubview(actionThree)
    }

    private func makeItRounded(view : UIView!, newSize : CGFloat!){
        let saveCenter : CGPoint = view.center
        let newFrame : CGRect = CGRect.init(x: view.frame.origin.x, y: view.frame.origin.y, width: newSize, height: newSize)
        view.frame = newFrame
        view.layer.cornerRadius = newSize / 2.0
        view.clipsToBounds = true
        view.center = saveCenter
    }
    
    private func addCirle(arcRadius: CGFloat, capRadius: CGFloat, color: UIColor, strokeStart : CGFloat, strokeEnd : CGFloat) {
        
        let centerPoint = CGPoint.init(x: self.bounds.midX , y: self.bounds.midY)
        let startAngle = CGFloat(Double.pi / 2)
        let endAngle = CGFloat(Double.pi * 2 + Double.pi / 2)
        
        let path = UIBezierPath(arcCenter:centerPoint, radius: frame.width/2+5, startAngle:startAngle, endAngle:endAngle, clockwise: true).cgPath
        
        let arc = CAShapeLayer()
        arc.lineWidth = 2
        arc.path = path
        arc.strokeStart = strokeStart
        arc.strokeEnd = strokeEnd
        arc.strokeColor = color.cgColor
        arc.fillColor = UIColor.clear.cgColor
        arc.shadowColor = UIColor.black.cgColor
        arc.shadowRadius = 0
        arc.shadowOpacity = 0
        arc.shadowOffset = CGSize.zero
        layer.addSublayer(arc)
    }

    private func createProgressCircle(){
        let centerPoint = CGPoint.init(x: self.bounds.midX , y: self.bounds.midY)
        let startAngle = CGFloat(Double.pi / 2)
        let endAngle = CGFloat(Double.pi * 2 + Double.pi / 2)
        
        // Use UIBezierPath as an easy way to create the CGPath for the layer.
        // The path should be the entire circle.
        let circlePath = UIBezierPath(arcCenter:centerPoint, radius: frame.width/2+5, startAngle:startAngle, endAngle:endAngle, clockwise: true).cgPath
        
        // Setup the CAShapeLayer with the path, colors, and line width
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.shadowColor = UIColor.black.cgColor
        circleLayer.strokeColor = self.progressFullColor.cgColor
        circleLayer.lineWidth = 2.0;
        circleLayer.strokeStart = 0.0
        circleLayer.shadowRadius = 0
        circleLayer.shadowOpacity = 0
        circleLayer.shadowOffset = CGSize.zero
        
        // draw the colorful , nice progress circle
        circleLayer.strokeEnd = CGFloat(duration/progress)
        
        // Add the circleLayer to the view's layer's sublayers
        layer.addSublayer(circleLayer)
    }

    
    private func redrawStrokeEnd() {
        circleLayer.strokeEnd = CGFloat(duration/progress)
    }

    private func resetAnimationCircle(){
        stopTimer()
        duration = 0
        circleLayer.strokeEnd = 0
    }

    private func pauseLayer(layer : CALayer) {
        let pauseTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pauseTime
    }
    
    private func resumeLayer(layer : CALayer) {
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }

    // MARK: - Manage Timer
    
    private func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(LJRoundPlayerView.updateTime), userInfo: nil, repeats: true)
        
        //        if let theDelegate = self.delegate {
        //            theDelegate.interactivePlayerViewDidStartPlaying(self)
        //        }
    }
    
    private func stopTimer(){
        
        if(timer != nil) {
            timer.invalidate()
            timer = nil
            
            //            if let theDelegate = self.delegate {
            //                theDelegate.interactivePlayerViewDidStopPlaying(self)
            //            }
            
        }
        
    }
    
    func updateTime(){
        
        self.duration += 0.1
        let totalDuration = Int(self.duration)
        let min = totalDuration / 60
        let sec = totalDuration % 60
        
        timeLabel.text = NSString(format: "%i:%02i",min,sec ) as String
        
        if(self.duration >= self.progress)
        {
            stopTimer()
        }
        
    }
    
    /* Start timer and animation */
    func start(){
        self.startTimer()
    }
    
    /* Stop timer and animation */
    func stop(){
        self.stopTimer()
    }
    
    func restartWithProgress(duration : Double){
        progress = duration
        self.resetAnimationCircle()
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(LJRoundPlayerView.start), userInfo: nil, repeats: false)
    }
    
    func reset() {
        resetAnimationCircle()
        timeLabel.text = "0:00"
    }

}
