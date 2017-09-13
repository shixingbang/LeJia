//
//  RefuelViewController.swift
//  LeJia
//
//  Created by 王嘉宁 on 2017/5/14.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import UIKit
import SnapKit
import GSKStretchyHeaderView
import Alamofire

class RefuelViewController: UITableViewController, GSKStretchyHeaderViewStretchDelegate, CommitOrderDelegate {
    
    // MARK: - Properties
    
    var gasStationInfos = [GasStationInfo]() {
        didSet {
            self.clearAllNotice()
            self.tableView.reloadData()
            self.stretchHeaderView.subtitle = "附近有 \(gasStationInfos.count) 个加油站"
        }
    }
    
    fileprivate let cellIdentifier = "refuelCell"
    fileprivate let cellBackImages = [#imageLiteral(resourceName: "refuel_back_cell1"),
                                      #imageLiteral(resourceName: "refuel_back_cell2"),
                                      #imageLiteral(resourceName: "refuel_back_cell3"),
                                      #imageLiteral(resourceName: "refuel_back_cell4"),
                                      #imageLiteral(resourceName: "refuel_back_cell5")]
    
    lazy var backImageView: UIImageView = {
        let i = UIImageView()
        i.image = #imageLiteral(resourceName: "refuel_back_body")
        return i
    }()
    
    lazy var stretchHeaderView: LJStretchyHeaderView = { [unowned self] in
        let s = LJStretchyHeaderView(frame: Rect(0, 0, LJ.screenWidth, 200))
        s.contentView.backgroundColor = LJ.purpleDefault
        s.stretchDelegate = self
        s.title = "预约加油"
        s.subtitle = ""
        s.backImage = #imageLiteral(resourceName: "refuel_back_header")
        
        return s
    }()
    
    // MARK: - Lifecycle
    
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
            navigationController.navigationBar.backIndicatorImage = UIImage()
            navigationController.navigationBar.backIndicatorTransitionMaskImage = UIImage()
            let item = UIBarButtonItem()
            item.image = #imageLiteral(resourceName: "signup_button_back")
            navigationItem.backBarButtonItem = item
            
            // 设置菜单按钮
            let menuButton = UIButton(frame: Rect(0, 0, 30, 30))
            menuButton.setImage(#imageLiteral(resourceName: "music_btn_menu"), for: .normal)
            menuButton.addTarget(self, action: .showMenu, for: .touchUpInside)
            let menuBarItem = UIBarButtonItem(customView: menuButton)
            navigationItem.leftBarButtonItem = menuBarItem
            
            // 设置订单按钮
            let orderButton = UIButton(frame: Rect(0, 0, 30, 30))
            orderButton.setImage(#imageLiteral(resourceName: "refuel_btn_order"), for: .normal)
            orderButton.addTarget(self, action: .showOrder, for: .touchUpInside)
            let orderBarItem = UIBarButtonItem(customView: orderButton)
            navigationItem.rightBarButtonItem = orderBarItem
            
            var contentInset = self.tableView.contentInset
            contentInset.top = 200
            self.tableView.contentInset = contentInset
        }
        
        initUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getGasStationInfo()
    }
    
    // MARK: - Init
    
    func initUI() {
//        // 下拉刷新
//        self.refreshControl = UIRefreshControl()
//        self.refreshControl?.addTarget(self, action: .refresh, for: UIControlEvents.valueChanged)
//        self.tableView.addSubview(refreshControl!)
//        tableView.backgroundColor = .white
        
        tableView.separatorStyle = .none
        tableView.tableHeaderView = UIView(frame: Rect(0, 0, LJ.screenWidth, 5))
        tableView.sectionFooterHeight = 1.0 // 减小 section 之间的间距
        
        tableView.register(RefuelTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.addSubview(stretchHeaderView)
        tableView.reloadData()
        
        backImageView.frame = Rect(0, 0, LJ.screenWidth, LJ.screenHeight)
        tableView.backgroundView = backImageView
        
        tableView.keyboardDismissMode = .onDrag // 滑动隐藏键盘 卧槽, 还有这么省事的API, 正犯难为, 太方便了
    }
    
    // MARK: - Action
    
    func getGasStationInfo() {
        
        self.pleaseWait()
        
        Alamofire.request(Router.getRefuelInfo()).responseJSON {
            response in
            switch response.result {
            case .success:
                guard let value = response.result.value else {
                    log("response.result.value is nil", .error)
                    return
                }
                let json = JSON(value)
                
                guard let status = json["code"].int else { return }
                guard status == 0 else {
                    log(json, .error)
                    self.noticeError("获取失败")
                    return
                }
                
                var tmpGasStationInfos = [GasStationInfo]()
                
                let gasStationResult = json["result"]["data"]
                let gasStationResultSize = gasStationResult.count
                
                for i in 0 ..< gasStationResultSize {
                    let gasInfoResult = gasStationResult[i]["gastprice"]
                    let gasInfoResultSize = gasInfoResult.count
                    var gasInfos = [GasPriceInfo]()
                    
                    for j in 0 ..< gasInfoResultSize {
                        let gasName = gasInfoResult[j]["name"].string!
                        let gasPrice = gasInfoResult[j]["price"].string!
                        let gasInfo = GasPriceInfo(name: gasName,
                                                   price: gasPrice)
                        gasInfos.append(gasInfo)
                    }

                    let gasStationName = gasStationResult[i]["name"].string!
                    let gasStationAddress = gasStationResult[i]["address"].string!
                    let gasStationBrandname = gasStationResult[i]["brandname"].string!
                    let gasStationType = gasStationResult[i]["type"].string!
                    let gasStationDiscount = gasStationResult[i]["discount"].string!
                    
                    let gasStationInfo = GasStationInfo(name: gasStationName,
                                                        address: gasStationAddress,
                                                        brandname: gasStationBrandname,
                                                        type: gasStationType,
                                                        discount: gasStationDiscount,
                                                        price: gasInfos)
                    tmpGasStationInfos.append(gasStationInfo)
                }
                
                self.gasStationInfos = tmpGasStationInfos
                
            case .failure(let error):
                self.clearAllNotice()
                self.noticeError("获取失败")
                log(error, .error)
            }
        }
    }
    
    // MARK: - Button Action
    
    func menuButtonTapped(_ sender: UIButton) {
        slideMenuController()?.toggleLeft()
    }
    
    func showOrderButtonTapped() {
        let myOrderTableViewController = MyOrderTableViewController()
        self.navigationController?.pushViewController(myOrderTableViewController, animated: true)
    }
    
    func beginRefreshing() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.refreshControl?.endRefreshing()
        })
    }
    
    func buttonTapped(_ sender: UIButton) {
        
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard gasStationInfos.count != 0 else { return 1 }
        
        return gasStationInfos.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard gasStationInfos.count != 0 else {
            let cell = UITableViewCell()
            return cell
        }
        
        let cell: RefuelTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RefuelTableViewCell
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        let row = indexPath.row
        
        let colorIndex = row % 4
        let color = LJ.cellColors[colorIndex]
        cell.color = color
        
        let gasStationInfo = gasStationInfos[row]
        
        cell.topLabel.text = gasStationInfo.name
        
        let backIndex = row % 5
        let backImage = cellBackImages[backIndex]
        cell.centerImageView.image = backImage
        
        cell.imageBundleLabelView.data = [("品牌", gasStationInfo.brandname),
                                          ("类型", gasStationInfo.type),
                                          ("折扣", gasStationInfo.discount)]
        
        cell.addressLabel.data = ("地址", gasStationInfo.address)
        
        var oilData = [(String, String)]()
        
        for gasInfo in gasStationInfo.price {
            oilData.append((gasInfo.name, gasInfo.price))
        }
        
        cell.oilBundleLabelButtonView.data = oilData
        
        cell.oilVolumeLabel.data = ("可购买油量", "0 升")
        
        cell.delegate = self
        
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
    
    // MARK: - CommitOrder Delegate
    
    func onShowHint(_ type: CommitOrderHint) {
        switch type {
        case .shouldLogin:
            self.noticeInfo("请先登录")
        case .shouldSelectGas:
            self.noticeOnlyText("请选择汽油种类")
        case .shouldEnterMoney:
            self.noticeOnlyText("请输入合法金额")
        }
    }
    
    func onCommit(_ orderInfo: OrderInfo) {
        log("接收到客户的订单请求", .happy)
        log("\n" + orderInfo.gasStation + "\n" +
            orderInfo.address + "\n" +
            orderInfo.gasName + "\n" +
            orderInfo.gasPrice + "\n" +
            orderInfo.orderMoney, .happy)
        
        SweetAlert().showAlert(
            "请确认订单",
            subTitle: "\(orderInfo.gasStation)\n汽油: \(orderInfo.gasName)\n金额: \(orderInfo.orderMoney)元",
            style: .none,
            buttonTitle: "取消",
            buttonColor: LJ.grayLightSearch,
            otherButtonTitle: "确定",
            otherButtonColor: LJ.greenWeChat) { (isOtherButton) -> () in
                guard isOtherButton == false else {
                    log("用户取消订单")
                    return
                }
                
                let token = UserManager.shared.getToken()
                
                Alamofire.request(Router.commitOrder(token, orderInfo)).responseJSON {
                    response in
                    switch response.result {
                    case .success:
                        guard let value = response.result.value else {
                            log("response.result.value is nil", .error)
                            return
                        }
                        let json = JSON(value)
                        
                        guard let status = json["code"].int else { return }
                        guard status == 0 else {
                            log(json, .error)
                            self.noticeError("提交订单失败")
                            return
                        }
                        log(json, .json)
                        self.clearAllNotice()
                        self.noticeSuccess("提交订单成功")
                        
                    case .failure(let error):
                        self.clearAllNotice()
                        self.noticeError("提交订单失败")
                        log(error, .error)
                    }
                }
        }
    }
}

fileprivate extension Selector {
    static let showMenu = #selector(RefuelViewController.menuButtonTapped(_:))
    static let showOrder = #selector(RefuelViewController.showOrderButtonTapped)
    static let refresh = #selector(RefuelViewController.beginRefreshing)
}
