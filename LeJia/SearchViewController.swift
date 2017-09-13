//
//  SearchViewController.swift
//  LeJia
//
//  Created by 王嘉宁 on 2017/5/15.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import UIKit

protocol SearchProtocol {
    func searchAround(_ keyword: String)
    func searchLocal(_ keyword: String)
    func selectResultRow(_ row: Int)
}


class SearchViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    /** 搜索条*/
    let searchBarView = MapSearchBarView(isOnMap: false)
    
    /** 代理*/
    var delegate: SearchProtocol?
    
    /** 结果列表*/
    lazy var tableView: UITableView = { [unowned self] in
        let t = UITableView(frame: .zero, style: .grouped) // section header 跟随滑动
        t.backgroundColor = UIColor.clear
        t.separatorStyle = .none
        //        t.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: LJ.leftMenuWidth, height: 5))
        //        t.tableFooterView = UIView() // 消除空白行
        t.sectionFooterHeight = 1.0 // 减小 section 之间的间距
        t.dataSource = self
        t.delegate = self
        return t
        }()
    
    /** 快捷搜索*/
    var collectionView: UICollectionView!
    
    /** 头部快捷选择地点*/
    //$$$$
    lazy var testImageView: UIImageView = {
        let i = UIImageView(frame: CGRect(x: 0, y: 0, width: LJ.screenWidth, height: 180))
        i.image = #imageLiteral(resourceName: "test_search_icons")
        return i
    }()
    
    fileprivate let cellIdentifier = "resultCell"
    fileprivate let collectionIdentifier = "searchCell"
    
    /** 搜索结果数据*/
    var data: NSArray?
    {
        didSet{
            tableView.reloadData()
        }
    }
    
    fileprivate let iconsData = [(#imageLiteral(resourceName: "search_icon_food"), "美食"),
                                 (#imageLiteral(resourceName: "search_icon_shopping"), "购物"),
                                 (#imageLiteral(resourceName: "search_icon_hotel"), "酒店"),
                                 (#imageLiteral(resourceName: "search_icon_attractions"), "景点"),
                                 (#imageLiteral(resourceName: "search_icon_bank"), "银行"),
                                 (#imageLiteral(resourceName: "search_icon_cinema"), "影院"),
                                 (#imageLiteral(resourceName: "search_icon_hospital"), "医院"),
                                 (#imageLiteral(resourceName: "search_icon_gasStation"), "加油")]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = LJ.whiteYellow
        
        initUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 每次进入的时候清空text
        searchBarView.searchTextField.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchBarView.searchTextField.becomeFirstResponder()
    }
    
    // MARK: - Init
    
    func initUI() {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 60, height: 90)
        
        // collectionView
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: LJ.screenWidth, height: 180), collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(SearchIconCollectionViewCell.self, forCellWithReuseIdentifier: collectionIdentifier)
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        
        [tableView, searchBarView].forEach {
            view.addSubview($0)
        }
        
        // tableView
        tableView.tableHeaderView = collectionView
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(80)
            make.bottom.left.right.equalToSuperview()
        }
        
        searchBarView.backButton.addTarget(self, action: .back, for: .touchUpInside)
        searchBarView.searchTextField.delegate = self
        
        searchBarView.snp.makeConstraints { (make) in
            make.height.equalTo(60)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(20)
        }
        
    }
    
    // MARK: - Button Action
    
    func backButtonTapped() {
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: - TextField Delegate
    
    /** 点击return搜索并隐藏键盘*/
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text =  searchBarView.searchTextField.text else {
            return true
        }
        delegate?.searchLocal(text)
        textField.resignFirstResponder()
        return true
    }
    
    /** 点击其他区域隐藏键盘*/
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBarView.searchTextField.resignFirstResponder()
    }
    
    // MARK: - ScrollView Delegate
    
    /** 滑动隐藏键盘 折中办法*/
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBarView.searchTextField.resignFirstResponder()
    }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard data != nil else {
            return 0
        }
        
        return data!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: SearchResultTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SearchResultTableViewCell
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        
        let row = indexPath.row
        
        let poi = data![row] as! AMapPOI
        cell.title = poi.name
        cell.subtitle = poi.address
        
        if poi.distance != 0 {
            cell.rightTitle = "\(poi.distance)m"
        } else {
            cell.rightTitle = ""
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        delegate?.selectResultRow(row)
        backButtonTapped()
    }
    
    // MARK: - CollectionView Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: SearchIconCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionIdentifier, for: indexPath) as! SearchIconCollectionViewCell
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        
        let row = indexPath.row
        
        let (icon, title) = iconsData[row]
        cell.image = icon
        cell.title = title
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let screenWidth = LJ.screenWidth
        guard screenWidth <= 375 else {
            return 20  // plus尺寸(414) 返回大间隙
        }
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBarView.searchTextField.resignFirstResponder()
        let row = indexPath.row
        let (_, title) = iconsData[row]
        self.searchBarView.searchTextField.text = title
        delegate?.searchAround(title)
    }
    
}

fileprivate extension Selector {
    static let back = #selector(SearchViewController.backButtonTapped)
}
