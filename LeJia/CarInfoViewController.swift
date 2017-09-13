//
//  CarInfoViewController.swift
//  LeJia
//
//  Created by 石兴帮 on 2017/5/31.
//  Copyright © 2017年 乐驾. All rights reserved.
//

import UIKit
import SnapKit
import GSKStretchyHeaderView
import Alamofire

class CarInfoViewController: UITableViewController, GSKStretchyHeaderViewStretchDelegate, QRCodeDelegate, checkMaintainingDelegate {

    // MARK: -properties
    
    var carInfos = [CarInfo]() {
        didSet {
            
            print("get infos")
            for car in carInfos {
                print(car.getDiscription())
            }
            
            self.clearAllNotice()
            self.tableView.reloadData()
            self.stretchHeaderView.subtitle = "共有 \(carInfos.count) 辆车"
        }
    }
        
    fileprivate let cellIdentifier = "carInfoCell"
    fileprivate let cellBackImages = [#imageLiteral(resourceName: "car_back_cell1"),
                                      #imageLiteral(resourceName: "car_back_cell2"),
                                      #imageLiteral(resourceName: "car_back_cell3"),
                                      #imageLiteral(resourceName: "car_back_cell4"),
                                      #imageLiteral(resourceName: "car_back_cell5")]

    lazy var backImageView: UIImageView = {
        let i = UIImageView()
        i.image = #imageLiteral(resourceName: "refuel_back_body")
        return i
    }()
    
    lazy var stretchHeaderView: LJStretchyHeaderView = { [unowned self] in
        let s = LJStretchyHeaderView(frame: Rect(0, 0, LJ.screenWidth, 200))
        s.contentView.backgroundColor = LJ.purpleDefault
        s.stretchDelegate = self
        s.title = "我的车辆"
        s.subtitle = ""
        s.backImage = #imageLiteral(resourceName: "car_back_header")
        
        return s
        }()

    
    // MARK: -lifecycle
    
    init() {
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.gray
        
        self.automaticallyAdjustsScrollViewInsets = false

        if let navigationController = self.navigationController {
            // 导航栏透明
            navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController.navigationBar.shadowImage = UIImage()
            navigationController.navigationBar.isTranslucent = true
            
            // 设置返回按钮
            let menuButton = UIButton(frame: Rect(0, 0, 30, 30))
            menuButton.setImage(#imageLiteral(resourceName: "music_btn_menu"), for: .normal)
            menuButton.addTarget(self, action: .showOrder, for: .touchUpInside)
            let menuBarItem = UIBarButtonItem(customView: menuButton)
            navigationItem.leftBarButtonItem = menuBarItem
            
            // 设置二维码按钮
            let qrButton = UIButton(frame: Rect(0, 0, 30, 30))
            qrButton.setImage(#imageLiteral(resourceName: "car_btn_scan"), for: .normal)
            qrButton.addTarget(self, action: .showQR, for: .touchUpInside)
            let qrBarItem = UIBarButtonItem(customView: qrButton)
            navigationItem.rightBarButtonItem = qrBarItem
            
            
            var contentInset = self.tableView.contentInset
            contentInset.top = 200
            self.tableView.contentInset = contentInset
        }

        initUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UserManager.addObserver(observer: self, selector: .userDidGetCarInfo, notification: .didGetCarInfo)
        UserManager.addObserver(observer: self, selector: .userDidGetCarInfoFailure, notification: .didGetCarInfoFailure)
        
        let logInStatus = UserManager.shared.isLogIn
        guard logInStatus == true else {
            self.errorNotice("请先登录～")
            return
        }
        
        getCarInfo()

    }

    // MARK: - Init
    
    func initUI() {
        
        tableView.separatorStyle = .none
        tableView.tableHeaderView = UIView(frame: Rect(0, 0, LJ.screenWidth, 5))
        tableView.sectionFooterHeight = 1.0 // 减小 section 之间的间距
        
        tableView.register(CarInfoTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.addSubview(stretchHeaderView)
        tableView.reloadData()
        
        backImageView.frame = Rect(0, 0, LJ.screenWidth, LJ.screenHeight)
        tableView.backgroundView = backImageView
        
        tableView.keyboardDismissMode = .onDrag // 滑动隐藏键盘 卧槽, 还有这么省事的API, 正犯难为, 太方便了
    }

    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard carInfos.count != 0 else { return 1 }
        
        return carInfos.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 419
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard carInfos.count != 0 else {
            let cell = UITableViewCell()
            return cell
        }
        
        let cell: CarInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CarInfoTableViewCell
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        let row = indexPath.row
//
        let colorIndex = row % 4
        let color = LJ.cellColors[colorIndex]
        cell.color = color
        
        let carInfo = carInfos[row]
        
        cell.topLabel.text = carInfo.brand + "-" + carInfo.plateNumber
        
        let backIndex = row % 5
        let backImage = cellBackImages[backIndex]
        cell.centerImageView.image = backImage
        
        cell.brandLabel.titleLabel.text = carInfo.brand
        cell.versionNumberLabel.titleLabel.text = carInfo.model
        
        cell.plateNumberLabel.titleLabel.text = carInfo.plateNumber
        cell.leftOilLabel.titleLabel.text = carInfo.leftOilVolume
        
        cell.archNumberLabel.text = carInfo.archNumber
        cell.motorNumberLabel.text = carInfo.motorNumber
        cell.distanceLabel.text = carInfo.distance
        
        cell.performanceBundleLabelView.leftLabel.titleLabel.text = carInfo.motorStatus
        cell.performanceBundleLabelView.centerLabel.titleLabel.text = carInfo.transStatus
        cell.performanceBundleLabelView.rightLabel.titleLabel.text = carInfo.lightStatus
        
        let url = "http://139.199.38.207:8000/logo/" + LJ.logoNameDic[carInfo.brand]!
        
        Alamofire.request(url).responseImage {
            response in
            guard let image = response.result.value as? UIImage else {
                log("convert to image failure", .error)
                log(response, .error)
                cell.archImageView.image = UIImage(named: "left_icon_defaultAvatar")
                UserManager.postNotification(.didGetUserAvatarFailure)
                return
            }
            cell.archImageView.image = image
        }
        
        cell.checkDelegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let section = indexPath.section
        //        let row = indexPath.row
        
    }

    
    // MARK: - GSKStretchyHeaderViewStretch Delegate
    
    func stretchyHeaderView(_ headerView: GSKStretchyHeaderView, didChangeStretchFactor stretchFactor: CGFloat) {
        //        log(stretchFactor, .ln)
    }

    // MARK: - Action
    
    func getCarInfo() {
        
        self.pleaseWait()
        
        UserManager.shared.getUserCarInfo()
        
    }
    
    // MARK: - Notifier Action
    
    func userDidGetCarInfo(notification: NSNotification) {
        self.clearAllNotice()
        self.carInfos = UserManager.shared.carInfos!
    }
    
    func userDidGetCarInfoFailure(notification: NSNotification) {
        self.clearAllNotice()
        self.carInfos = UserManager.shared.carInfos!
    }

    // MARK: - Button Action
    
    func qrButtonTapped(_ sender: UIButton) {
        let qrCodeViewController = ScanQRCodeViewController()
        qrCodeViewController.delegate = self
        self.navigationController?.pushViewController(qrCodeViewController, animated: true)
    }
    
    func showOrderButtonTapped(_ sender: UIButton) {
        slideMenuController()?.toggleLeft()
    }
    
    func beginRefreshing() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.refreshControl?.endRefreshing()
        })
    }
    
    func buttonTapped(_ sender: UIButton) {
        
    }

    // MARK: - QRReaderDelegate
    
    func onGetResult(result: NSDictionary) {
        let carInfo = CarInfo.init(brand: result["brand"]! as! String, model: result["model"]! as! String, plateNumber: result["plateNumber"] as! String, archNumber: result["archNumber"]! as! String, motorNumber: result["motorNumber"]! as! String, distance: result["distance"]! as! String, leftOilVolume: result["leftOilVolume"]! as! String, motorStatus: result["motorStatus"]! as! String, transStatus: result["transStatus"]! as! String, lightStatus: result["lightStatus"]! as! String)

        SweetAlert().showAlert("确定提交车辆信息?", subTitle: carInfo.getDiscription(), style: AlertStyle.warning, buttonTitle:"取 消", buttonColor:UIColor.colorFromRGB(0xD0D0D0) , otherButtonTitle:  "提 交", otherButtonColor: UIColor.colorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
            if isOtherButton == true {
                print("Cancel Button  Pressed", terminator: "")
            }
            else {
                let _ = SweetAlert().showAlert("已向服务器提交!", subTitle: "您的车辆信息已经向服务器提交，请等待！", style: AlertStyle.success)
                Alamofire.request(Router.addCarInfo(UserManager.shared.getToken(), carInfo)).responseJSON { json in
                    switch json.result {
                    case .success:
                        if let value = json.result.value {
                            let json = JSON(value)
                            let code = json["code"]
                            if code != 0 {
                                print("commit car info failure")
                                print(json)
                                self.clearAllNotice()
                                self.errorNotice("提交失败!")
                            }else{
                                self.clearAllNotice()
                                self.noticeTop("提交成功！")
                                self.getCarInfo()
                            }
                        }
                    case .failure(let error):
                        print(error)
                        self.clearAllNotice()
                        self.errorNotice("提交失败!")
                    }
                }

            }
        }
    }
    
    // MARK: - checkMaintainingDelegate
    
    func onCheckMaintaining() {
        
    }
}

fileprivate extension Selector {
    static let showQR = #selector(CarInfoViewController.qrButtonTapped(_:))
    static let showOrder = #selector(CarInfoViewController.showOrderButtonTapped(_:))
    static let refresh = #selector(CarInfoViewController.beginRefreshing)

}

