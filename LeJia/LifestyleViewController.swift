//
//  LifestyleViewController.swift
//  LeJia
//
//  Created by 王嘉宁 on 2017/5/31.
//  Copyright © 2017年 乐驾. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire

struct LifestyleMargin {
    
    static var leftMargin: CGFloat {
        if LJ.screenWidth <= 320 {
            return 10
        } else {
            return 20
        }
    }
    
    static var newsCellWidth: CGFloat {
        if LJ.screenWidth <= 320 {
            return 290
        } else {
            return 325
        }
    }
    
}

class LifestyleViewController: UITableViewController, ChooseCityProtocol {
    
    // MARK: - Properties
    
    fileprivate let sectionTitle = ["新闻", "服务", "违章查询"]
    fileprivate let newsData = [("新时代的暴力美学 测试奔驰AMG C 63", #imageLiteral(resourceName: "lifestyle_news_1_benz"),
                                  "http://www.autohome.com.cn/drive/201510/880252.html"),
                                 ("终于等到你 试驾全新一代奥迪A4L", #imageLiteral(resourceName: "lifestyle_news_2_audi"),
                                  "http://www.autohome.com.cn/drive/201608/891937.html"),
                                 ("全新沃尔沃 S90 长轴距版 试驾", #imageLiteral(resourceName: "lifestyle_news_3_volvo"),
                                  "http://www.zealer.com/post/739"),
                                 ("当 ZEALER 遇见特斯拉 Model X", #imageLiteral(resourceName: "lifestyle_news_4_model_x"),
                                  "http://www.zealer.com/post/309"),
                                 ("气派的完美展现 测奔驰E 320 L 4MATIC", #imageLiteral(resourceName: "lifestyle_news_5_benz"),
                                  "http://www.autohome.com.cn/drive/201701/898067.html")]
    
    fileprivate let serviceData = [("自驾游", "途牛", #imageLiteral(resourceName: "lifestyle_service_self-driving_1"),
                                       "http://www.tuniu.com/"),
                                      ("爱车出售", "瓜子", #imageLiteral(resourceName: "lifestyle_service_car_deal_1"),
                                       "https://www.guazi.com/"),
                                      ("驾车出行", "同程", #imageLiteral(resourceName: "lifestyle_service_self-driving_2"),
                                       "http://www.ly.com/"),
                                      ("购车贷款", "人人贷", #imageLiteral(resourceName: "lifestyle_service_car_deal_2"),
                                       "https://www.renrendai.com/"),]
    
    fileprivate let sectionCellIdentifier = "sectionCell"
    fileprivate let carCellIdentifier = "carCell"
    fileprivate let violationCellIdentifier = "violationCell"
    
    let app_id = "1796"
    let app_key = "53f6084c94a62a2f8221001bed2a47a5"

    var violationCars:[CarInfo] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    var cityId = 189
    var changeCityButton: UIButton!
    
    var provinceInfo: [ProvinceInfo]!
    {
        didSet{
            changeCityButton.isHidden = false
            var index = 0
            for i in 0 ..< provinceInfo.count {
                for j in 0 ..< provinceInfo[i].citys.count {
                    chooseCityViewController.cityData.insert(ProvinceCityInfo(id: provinceInfo[i].citys[j].id, city: provinceInfo[i].citys[j].name, province: provinceInfo[i].name, provinceCity: provinceInfo[i].name + provinceInfo[i].citys[j].name), at: index)
                    index += 1
                }
            }
        }
    }
    
    var chooseCityViewController: ChooseCityViewController!
    /// 新闻横向滑动视图
    var newsHorizontalScrollView: ASHorizontalScrollView!
    /// 服务横向滑动视图
    var serviceHorizontalScrollView: ASHorizontalScrollView!
    
    // MARK: - Lifecycle
    
    init() {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        if let navigationController = self.navigationController {
            navigationController.navigationBar.backgroundColor = .white
            navigationController.navigationBar.isTranslucent = false
            
            // 设置返回按钮
            navigationController.navigationBar.backIndicatorImage = UIImage()
            navigationController.navigationBar.backIndicatorTransitionMaskImage = UIImage()
            let item = UIBarButtonItem()
            item.image = #imageLiteral(resourceName: "lifestyle_btn_back")
            navigationItem.backBarButtonItem = item
            
            // 设置菜单按钮
            let menuButton = UIButton(frame: Rect(0, 0, 30, 30))
            menuButton.setImage(#imageLiteral(resourceName: "lifestyle_btn_menu"), for: .normal)
            menuButton.addTarget(self, action: .showMenu, for: .touchUpInside)
            let menuBarItem = UIBarButtonItem(customView: menuButton)
            navigationItem.leftBarButtonItem = menuBarItem
            
            navigationItem.title = "乐驾生活"
            
        }
        initUI()
        getViolationCars()
        initChooseViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.register(ViolationCell.self, forCellReuseIdentifier: violationCellIdentifier)
        UserManager.addObserver(observer: self, selector: .userDidGetCarInfo, notification: .didGetCarInfo)
        UserManager.addObserver(observer: self, selector: .userDidGetCarInfoFailure, notification: .didGetCarInfoFailure)
    }
    // MARK: - Init
    
    func initUI() {
        
        tableView.separatorStyle = .none
        tableView.tableHeaderView = UIView(frame: Rect(0, 0, LJ.screenWidth, 5))
        tableView.sectionFooterHeight = 1.0
        
    }
    
    func initChooseViewController() {
        chooseCityViewController = ChooseCityViewController()
        chooseCityViewController.delegate = self
    }
    
    // MARK: - Action 
    
    func getViolationCars() {
        guard UserManager.shared.carInfos != nil else {
            UserManager.shared.getUserCarInfo()
            return
        }
        self.violationCars = UserManager.shared.carInfos!
    }
    
//    func checkDriveStatus(id: Int) {
//    
//    }

    // MARK: - Button Action
    func chooseCityButtonTapped() {
//        self.present(chooseCityViewController, animated: true, completion: nil)
    }
    
    func menuButtonTapped() {
        slideMenuController()?.toggleLeft()
    }
    
    // MARK: - Tap Action
    
    func newsTapAction(gesture: UITapGestureRecognizer) {
        if let index = newsHorizontalScrollView.items.index(of: gesture.view!) {
            let url = newsData[index].2
            let webViewController = WebViewController(url: url, title: "乐驾新闻")
            self.navigationController?.pushViewController(webViewController, animated: true)
        }
    }
    
    func serviceTapAction(gesture: UITapGestureRecognizer) {
        if let index = serviceHorizontalScrollView.items.index(of: gesture.view!) {
            let url = serviceData[index].3
            let title = serviceData[index].1
            let webViewController = WebViewController(url: url, title: title)
            self.navigationController?.pushViewController(webViewController, animated: true)
        }
    }
    
    // MARK: - Notifier Action
    
    func userDidGetCarInfo(notification: NSNotification) {
        self.clearAllNotice()
        self.violationCars = UserManager.shared.carInfos!
    }
    
    func userDidGetCarInfoFailure(notification: NSNotification) {
        self.clearAllNotice()
        self.violationCars = UserManager.shared.carInfos!
    }
    
    // MARK: - TableView Delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return LJ.controlsHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        
        if section == 2 {
            print(violationCars[indexPath.row].getDiscription())
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: LJ.screenWidth, height: LJ.controlsHeight))
        headerView.backgroundColor = .clear
        
        let headerLabel = UILabel(frame: CGRect(x: 20, y: 0, width: LJ.screenWidth, height: LJ.controlsHeight))
        headerLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightMedium)
        headerLabel.text = sectionTitle[section]
        headerView.addSubview(headerLabel)
        
        if section == 2 {
            changeCityButton = UIButton.init()
            changeCityButton.setTitleColor(LJ.redDefault, for: .normal)
            changeCityButton.setTitle("济南", for: .normal)
            changeCityButton.addTarget(self, action: #selector(LifestyleViewController.chooseCityButtonTapped), for: .touchUpInside)
            headerView.addSubview(changeCityButton)
            changeCityButton.snp.makeConstraints {
                (make) in
                make.width.equalTo(40)
                make.height.equalTo(25)
                make.top.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-15)
            }
        }
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 1:
            return 1
        case 2:
            return violationCars.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        switch section {
        case 0:
            return 200
        case 1:
            return 130
        case 2:
            return 80
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        //let row = indexPath.row
        
        if section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: violationCellIdentifier) as! ViolationCell
            cell.carBrandLabel.text = violationCars[indexPath.row].brand
            cell.plateLabel.text = "车牌号: " + violationCars[indexPath.row].plateNumber
            let url = "http://139.199.38.207:8000/logo/" + LJ.logoNameDic[violationCars[indexPath.row].brand]!
            
            Alamofire.request(url).responseImage {
                response in
                guard let image = response.result.value as? UIImage else {
                    log("convert to image failure", .error)
                    log(response, .error)
                    cell.carLogoImageView.image = UIImage(named: "left_icon_defaultAvatar")
                    UserManager.postNotification(.didGetUserAvatarFailure)
                    return
                }
                cell.carLogoImageView.image = image
            }
            

            return cell
        }
        
        var cell = tableView.dequeueReusableCell(withIdentifier: sectionCellIdentifier)
        
        if (cell == nil) {
            
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: sectionCellIdentifier)
            cell?.selectionStyle = .none
            
            if section == 0 {
                
                newsHorizontalScrollView = ASHorizontalScrollView(frame:CGRect(x: 0, y: 0, width: LJ.screenWidth, height: 200))
                
                newsHorizontalScrollView.defaultMarginSettings = MarginSettings(leftMargin: LifestyleMargin.leftMargin, miniMarginBetweenItems: 0, miniAppearWidthOfLastItem: 20)
                
                newsHorizontalScrollView.uniformItemSize = CGSize(width: LifestyleMargin.newsCellWidth + 10, height: 200)
                newsHorizontalScrollView.setItemsMarginOnce()
                
                let cellImageSize = CGSize(width: LifestyleMargin.newsCellWidth, height: 180)
                
                for (cellTitle, cellImage, _) in newsData{
                    let newsCell = NewsCell(imageSize: cellImageSize)
                    newsCell.image = cellImage
                    newsCell.title = cellTitle
                    
                    let tapGesture = UITapGestureRecognizer(target: self, action: .newsTap)
                    tapGesture.numberOfTapsRequired = 1
                    tapGesture.numberOfTouchesRequired = 1
                    newsCell.addGestureRecognizer(tapGesture)
                    
                    newsHorizontalScrollView.addItem(newsCell)
                }
                
                cell?.contentView.addSubview(newsHorizontalScrollView)
                
            } else if section == 1 {
                
                serviceHorizontalScrollView = ASHorizontalScrollView(frame:CGRect(x: 0, y: 0, width: LJ.screenWidth, height: 130))
                
                serviceHorizontalScrollView.defaultMarginSettings = MarginSettings(leftMargin: LifestyleMargin.leftMargin, miniMarginBetweenItems: 10, miniAppearWidthOfLastItem: 20)
                
                serviceHorizontalScrollView.uniformItemSize = CGSize(width: 80+2, height: 130)
                serviceHorizontalScrollView.setItemsMarginOnce()
                
                let cellImageSize = CGSize(width: 80, height: 80)
                
                for (cellTitle, cellSubTitle, cellImage, _) in serviceData {
                    let serviceCell = ServiceCell(imageSize: cellImageSize)
                    serviceCell.image = cellImage
                    serviceCell.title = cellTitle
                    serviceCell.subtitle = cellSubTitle
                    
                    let tapGesture = UITapGestureRecognizer(target: self, action: .serviceTap)
                    tapGesture.numberOfTapsRequired = 1
                    tapGesture.numberOfTouchesRequired = 1
                    serviceCell.addGestureRecognizer(tapGesture)
                    
                    serviceHorizontalScrollView.addItem(serviceCell)
                }
                
                for (cellTitle, cellSubTitle, cellImage, _) in serviceData {
                    let serviceCell = ServiceCell(imageSize: cellImageSize)
                    serviceCell.image = cellImage
                    serviceCell.title = cellTitle
                    serviceCell.subtitle = cellSubTitle
                    serviceHorizontalScrollView.addItem(serviceCell)
                }
                
                cell?.contentView.addSubview(serviceHorizontalScrollView)
//                horizontalScrollView.translatesAutoresizingMaskIntoConstraints = false
//                cell?.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 130))
//                cell?.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: cell!.contentView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0))
                
            }
        }
        else if let horizontalScrollView = cell?.contentView.subviews.first(where: { (view) -> Bool in
            return view is ASHorizontalScrollView
        }) as? ASHorizontalScrollView {
            horizontalScrollView.refreshSubView() //refresh view incase orientation changes
        }
        return cell!
    }
    
    // MARK: - Choose City Delegate
    
    func didChooseCity(cityId: Int, cityName: String) {
        self.cityId = cityId
        self.changeCityButton.setTitle(cityName, for: .normal)
    }
    
}

fileprivate extension Selector {
    static let showMenu = #selector(LifestyleViewController.menuButtonTapped)
    static let newsTap = #selector(LifestyleViewController.newsTapAction(gesture:))
    static let serviceTap = #selector(LifestyleViewController.serviceTapAction(gesture:))
}







