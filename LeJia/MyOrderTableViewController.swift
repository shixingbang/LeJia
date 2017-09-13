//
//  MyOrderTableViewController.swift
//  LeJia
//
//  Created by 石兴帮 on 2017/6/14.
//  Copyright © 2017年 乐驾. All rights reserved.
//

import UIKit
import SnapKit
import GSKStretchyHeaderView
import Alamofire

class MyOrderTableViewController: UITableViewController, GSKStretchyHeaderViewStretchDelegate, cancelOrderProtocol{
    
    // MARK: - Properties 
    
    var orderInfos: [OrderInfo] = [] {
        didSet {
            self.clearAllNotice()
            self.tableView.reloadData()
            self.stretchHeaderView.subtitle = "共有 \(orderInfos.count) 个订单"
        }
    }
    
    var orderQRs: [UIImage] = [] {
        didSet {
            self.clearAllNotice()
            self.tableView.reloadData()
        }
    }
    
    lazy var backImageView: UIImageView = {
        let i = UIImageView()
        i.image = #imageLiteral(resourceName: "refuel_back_body")
        return i
    }()
    
    lazy var stretchHeaderView: LJStretchyHeaderView = { [unowned self] in
        let s = LJStretchyHeaderView(frame: Rect(0, 0, LJ.screenWidth, 200))
        s.contentView.backgroundColor = LJ.purpleDefault
        s.stretchDelegate = self
        s.title = "我的订单"
        s.subtitle = ""
        s.backImage = #imageLiteral(resourceName: "refuel_back_header")
        
        return s
        }()
    
    fileprivate let cellIdentifier = "myOrderCell"
    fileprivate let cellBackImages = [#imageLiteral(resourceName: "refuel_back_cell1"),
                                      #imageLiteral(resourceName: "refuel_back_cell2"),
                                      #imageLiteral(resourceName: "refuel_back_cell3"),
                                      #imageLiteral(resourceName: "refuel_back_cell4"),
                                      #imageLiteral(resourceName: "refuel_back_cell5")]

    // MARK: - lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.gray
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        if let navigationController = self.navigationController {
            // 导航栏透明
            navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController.navigationBar.shadowImage = UIImage()
            navigationController.navigationBar.isTranslucent = true
            
            let backButton = UIButton(frame: Rect(0, 0, 30, 30))
            backButton.setImage(#imageLiteral(resourceName: "signup_button_back"), for: .normal)
            backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
            let menuBarItem = UIBarButtonItem(customView: backButton)
            navigationItem.leftBarButtonItem = menuBarItem
            
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
        
        UserManager.addObserver(observer: self, selector: .userDidGetOrderInfo, notification: .didGetOrderInfo)
        UserManager.addObserver(observer: self, selector: .userDidGetOrderInfoFailure, notification: .didGetOrderInfoFailure)
        
        let logInStatus = UserManager.shared.isLogIn
        guard logInStatus == true else {
            self.errorNotice("请先登录～")
            return
        }
        
        getOrderInfo()

    }
    // MARK: - Init
    
    func initUI() {
        
        tableView.separatorStyle = .none
        tableView.tableHeaderView = UIView(frame: Rect(0, 0, LJ.screenWidth, 5))
        tableView.sectionFooterHeight = 1.0 // 减小 section 之间的间距
        
        tableView.register(MyOrderTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.addSubview(stretchHeaderView)
        tableView.reloadData()
        
        backImageView.frame = Rect(0, 0, LJ.screenWidth, LJ.screenHeight)
        tableView.backgroundView = backImageView
        
        tableView.keyboardDismissMode = .onDrag // 滑动隐藏键盘 卧槽, 还有这么省事的API, 正犯难为, 太方便了
    }
    
    // MARK: - Action 
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getOrderInfo() {
        self.pleaseWait()
        
        UserManager.shared.getUserOrderInfo()
    }
    
    // MARK: - Notifier Action
    
    func userDidGetOrderInfo(notification: NSNotification) {
        self.clearAllNotice()
        self.orderInfos = UserManager.shared.orderInfos!
        
        let orderCount = orderInfos.count

        for i in 0 ..< orderCount {
            Alamofire.request(Router.getOrderQRCode(UserManager.shared.getToken(), orderInfos[i].id!)).responseImage {
                response in
                log(response, .url)
                guard let image = response.result.value as? UIImage else {
                    log("convert to image failure", .error)
                    log(response, .error)
                    self.orderQRs.append(#imageLiteral(resourceName: "test_avatar2"))
                    return
                }
                self.orderQRs.append(image)
            }
        }
    }
    
    func userDidGetOrderInfoFailure(notification: NSNotification) {
        self.clearAllNotice()
        self.orderInfos = UserManager.shared.orderInfos!
    }

    
    // MARK: - GSKStretchyHeaderViewStretch Delegate
    
    func stretchyHeaderView(_ headerView: GSKStretchyHeaderView, didChangeStretchFactor stretchFactor: CGFloat) {
        //        log(stretchFactor, .ln)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        guard orderInfos.count != 0 else { return 1 }
        
        return orderInfos.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 560
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard orderInfos.count != 0 else {
            let cell = UITableViewCell()
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myOrderCell", for: indexPath) as! MyOrderTableViewCell
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        let row = indexPath.row
        
        let colorIndex = row % 4
        let color = LJ.cellColors[colorIndex]
        cell.color = color

        let backIndex = row % 5
        let backImage = cellBackImages[backIndex]
        cell.centerImageView.image = backImage
        
        let orderInfo = orderInfos[row]
        
        cell.topLabel.text = orderInfo.gasStation
        cell.imageBundleLabelView.data = [("汽油", orderInfo.gasName),
                                          ("价格", orderInfo.gasPrice),
                                          ("折扣", "打折加油站")]
        cell.orderNumLabel.titleLabel.text = orderInfo.no
        cell.orderPriLabel.titleLabel.text = orderInfo.orderMoney
        cell.addressLabel.titleLabel.text = orderInfo.address
        
        cell.delegate = self
        
        let qrCount = self.orderQRs.count
        guard qrCount > 0 else {
            return cell
        }
        
        cell.qrImageView.image = self.orderQRs[row]
        
        return cell
    }
    
    // MARK: - cancelOrderProtocol
    
    func orderCanceled() {
        self.noticeError("功能开发中～")
    }
}
