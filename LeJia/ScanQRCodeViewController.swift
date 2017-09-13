//
//  ScanQRCodeViewController.swift
//  LeJia
//
//  Created by 石兴帮 on 2017/5/31.
//  Copyright © 2017年 乐驾. All rights reserved.
//

import UIKit
import AVFoundation

protocol QRCodeDelegate {
    func onGetResult(result: NSDictionary)
}

class ScanQRCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    // MARK: - Properties
    
    /// 捕捉会话
    var captureSession: AVCaptureSession!
    
    var viewPreview: UIView!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var boxView: UIView!
    var scanLayer: CALayer!
    
    var imageOne: UIImageView!
    var imageTwo: UIImageView!
    var closeButton: UIButton!
    
    var timer: Timer!
    
    var delegate: QRCodeDelegate?
//    self.id = id
//    self.brand = brand
//    self.model = model
//    self.plateNumber = plateNumber
//    self.archNumber = archNumber
//    self.motorNumber = motorNumber
//    self.distance = distance
//    self.leftOilVolume = leftOilVolume
//    self.motorStatus = motorStatus
//    self.transStatus = transStatus
//    self.lightStatus = lightStatus

    let resultArray = ["app","brand","model","plateNumber","distance","archNumber","motorNumber","motorStatus","transStatus","lightStatus","leftOilVolume"]
    let resultDic = ["app": "","brand": "","model": "","plateNumber": "","distance": "","archNumber": "","motorNumber": "","motorStatus": "","transStatus": "","lightStatus": "","leftOilVolume": ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let logInStatus = UserManager.shared.isLogIn
        guard logInStatus == true else {
            self.errorNotice("请先登录～")
            sleep(1)
            self.navigationController?.popViewController(animated: true)
            
            return
        }
        
        let _ = self.startReading()
    }
    
    // MARK: - Init
    
    func createUI() {
        initViewPreview()
        initSession()
        initViewPreviewLayer()
        initBoxView()
        initScanLayer()
        
        initImageOne()
        initImageTwo()
        initCloseButton()
    }
    
    func initViewPreview() {
        viewPreview = UIView(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        viewPreview.backgroundColor = UIColor.lightGray
        self.view.addSubview(viewPreview)
    }
    
    func initSession() {
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        var input:AVCaptureDeviceInput
        do{
            input = try AVCaptureDeviceInput(device: captureDevice)
        }catch{
            print("Error")
            return
        }
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession = AVCaptureSession()
        captureSession.addInput(input)
        captureSession.addOutput(captureMetadataOutput)
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        captureMetadataOutput.rectOfInterest = CGRect.init(x: 0.2, y: 0.2, width: 0.8, height: 0.8)
    }
    
    func initViewPreviewLayer() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.frame = viewPreview.layer.bounds
        viewPreview.layer.addSublayer(videoPreviewLayer)
    }
    
    func initBoxView() {
        boxView = UIView(frame: CGRect.init(x: 40, y: viewPreview.bounds.size.height * 0.2, width: viewPreview.bounds.size.width - 80, height: viewPreview.bounds.size.height - viewPreview.bounds.size.height * 0.4))
        boxView.layer.borderColor = UIColor.white.cgColor
        boxView.layer.borderWidth = 1.0
        viewPreview.addSubview(boxView)
    }
    
    func initScanLayer() {
        scanLayer = CALayer()
        scanLayer.frame = CGRect.init(x: 0, y: 0, width: boxView.bounds.size.width, height: 1)
        scanLayer.backgroundColor = UIColor.green.cgColor
        boxView.layer.addSublayer(scanLayer)
    }
    
    func initImageOne() {
        imageOne = UIImageView(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: 127))
        imageOne.image = UIImage(named: "image_qrbackOne")
        self.view.addSubview(imageOne)
    }
    
    func initImageTwo() {
        imageTwo = UIImageView(frame: CGRect.init(x: 0, y: self.view.bounds.height - 106, width: self.view.bounds.width, height: 106))
        imageTwo.image = UIImage(named: "image_qrbackTwo")
        self.view.addSubview(imageTwo)
    }
    
    func initCloseButton() {
        closeButton = UIButton(frame: CGRect.init(x: 10, y: 35, width: 30, height: 30))
        closeButton.setImage(UIImage(named: "button_navi_close"), for: UIControlState.normal)
        closeButton.addTarget(self, action: #selector(ScanQRCodeViewController.closeButtonTapped), for: UIControlEvents.touchUpInside)
        self.view.addSubview(closeButton)
    }
    
    // MARK: - Manage QRCode Reading
    
    func startReading() -> Bool{
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(ScanQRCodeViewController.moveScanLayer), userInfo: nil, repeats: true)
        captureSession.startRunning()
        return true
    }
    
    func moveScanLayer() {
        var frame = scanLayer.frame
        if boxView.frame.size.height < scanLayer.frame.origin.y {
            frame.origin.y = 0
            scanLayer.frame = frame
        }else{
            frame.origin.y += 5
            UIView.animate(withDuration: 0.1, animations: {
                self.scanLayer.frame = frame
            })
        }
    }
    
    func stopReading() {
        captureSession.stopRunning()
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if (metadataObjects != nil && metadataObjects.count > 0) {
            let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            self.performSelector(onMainThread: #selector(ScanQRCodeViewController.checkText), with: metadataObj.stringValue, waitUntilDone: false)
        }

    }
    
    func checkText(text: String) {
        print("!!!")
        let string = text.components(separatedBy: ",")
        let check = string[0]
        if check == "乐驾" && string.count == 11 {
            var result = resultDic
            for i in 0 ..< resultArray.count {
                result[resultArray[i]] = string[i]
            }
            print(result)
            
            delegate?.onGetResult(result: result as NSDictionary)
            stopReading()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func closeButtonTapped() {
        stopReading()
        self.dismiss(animated: true, completion: nil)
    }


}
