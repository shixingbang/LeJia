//
//  MainViewController.swift
//  LeJia
//
//  Created by 王嘉宁 on 2017/5/14.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import UIKit
import SnapKit

//$$$$
var userCity = ""

class MainViewController: UIViewController, MAMapViewDelegate, AMapNaviDriveManagerDelegate, AMapNaviDriveViewDelegate, AMapSearchDelegate, SearchProtocol {
    
    // MARK: - Properties
    
    // MARK: - 地图相关
    
    /** 地图*/
    var mapView: MAMapView!
    
    /** 搜索条*/
    let searchBarView = MapSearchBarView(isOnMap: true)
    
    /** 右侧按钮组*/
    let rightGroupButtonView = MapButtonGroupView()
    
    /** 当前位置*/
    var currentLocation: CLLocation?
    
    /** 进入应用后再第一次取得地理位置后 设置为true*/
    var isFirstSetMapLocationDone = false
    
    /** 标记*/
    var annotations: NSMutableArray? = NSMutableArray()
    let annotationReuseIdentifier = "annotationReuseIdentifier"
    
    /** 长按手势放置大头针*/
    var longPressGesture: UILongPressGestureRecognizer?
    
    /** 大头针*/
    var pinAnnotation: MAPointAnnotation?
    let pinAnnotationReuseIdentifier = "startAnnotationReuseIdentifier"
    
    /** 获取用户所在城市*/
    var locationManager: CLLocationManager!
    
    // MARK: - 搜索相关
    
    lazy var mapSearch: AMapSearchAPI = { [unowned self] in
        let s = AMapSearchAPI()
        s!.delegate = self
        return s!
        }()
    
    lazy var searchViewController: SearchViewController = { [unowned self] in
        let s = SearchViewController()
        s.delegate = self
        return s
        }()
    
    /** 搜索得到的位置数组*/
    var pois: NSArray?
    {
        didSet{
            poisSearchDone()
        }
    }
    
    // MARK: - 导航相关
    
    lazy var driveManager: AMapNaviDriveManager = { [unowned self] in
        let m = AMapNaviDriveManager()
        m.allowsBackgroundLocationUpdates = true
        m.pausesLocationUpdatesAutomatically = false
        m.delegate = self
        return m
        }()
    
    var driveView: AMapNaviDriveView?
    
    var naviStartPoint: AMapNaviPoint = AMapNaviPoint()
    var naviEndPoint: AMapNaviPoint?
    
    /** 轻点返回地图手势*/
    lazy var tapGesture: UITapGestureRecognizer = { [unowned self] in
        let t = UITapGestureRecognizer(target: self, action: .closeNavi)
        t.numberOfTapsRequired = 1 // 点击次数
        t.numberOfTouchesRequired = 1 // 点击手指数
        return t
        }()
    
    lazy var mapNaviMaskView: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        v.alpha = 0.4
        return v
    }()
    
    lazy var mapNavigationView: MapNavigationView = { [unowned self] in
        let n = MapNavigationView(frame: CGRect(x: 0, y: LJ.screenHeight, width: LJ.screenWidth, height: 200))
        n.closeButton.addTarget(self, action: .closeNavi, for: .touchUpInside)
        n.naviButton.addTarget(self, action: .navi, for: .touchUpInside)
        return n
        }()
    
    /** 当前选中状态 0: 未选中 1: 选中大头针 2: 选中标记*/
    var currentSelectState = 0
    
    // MARK: - 语音相关
    
    /** 区分是语音搜索还是手动搜索*/
    var isSpeechSearch = false
    
    /// 气泡过渡动画
    let bubbleTransition = BubbleTransition()
    
    /// 弹出语音界面
    @IBOutlet weak var speechButton: UIButton!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray
        initUI()
    }
    
    deinit {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Init
    
    func initUI() {
        // speech button
        speechButton.layer.cornerRadius = 30
        speechButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        speechButton.layer.shadowOpacity = 0.3
        speechButton.layer.shadowRadius = 1
        
        // mapView
        AMapServices.shared().enableHTTPS = true
        mapView = MAMapView(frame: self.view.bounds)
        mapView.delegate = self
        mapView.compassOrigin = CGPoint(x: mapView.compassOrigin.x, y: LJ.screenHeight - 45)
        mapView.scaleOrigin = CGPoint(x: mapView.scaleOrigin.x, y: LJ.screenHeight - 45)
        mapView.showsUserLocation = true
        
        // user location
//        let userLocationView = MAUserLocationRepresentation()
//        userLocationView.showsAccuracyRing = false
//        userLocationView.showsHeadingIndicator = false
//        userLocationView.fillColor = .red
//        userLocationView.strokeColor = .blue
//        userLocationView.lineWidth = 2
//        userLocationView.enablePulseAnnimation = false
//        userLocationView.locationDotBgColor = .green
//        userLocationView.locationDotFillColor = .gray
//        mapView.update(userLocationView)
        
        // searchBarView
        searchBarView.menuButton.addTarget(self, action: .showMenu, for: .touchUpInside)
        searchBarView.showSearchButton.addTarget(self, action: .search, for: .touchUpInside)
        
        // rightGroupButtonView
        rightGroupButtonView.locationButton.addTarget(self, action: .locate, for: .touchUpInside)
        rightGroupButtonView.naviButton.addTarget(self, action: .showNavi, for: .touchUpInside)
        
        // locationManager
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }else{
            log("can not get location!", .error)
        }
        
        [mapView, searchBarView, rightGroupButtonView].forEach {
            view.insertSubview($0, belowSubview: speechButton)
        }
        
        searchBarView.snp.makeConstraints { (make) in
            make.height.equalTo(60)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(20)
        }
        
        rightGroupButtonView.snp.makeConstraints { (make) in
            make.height.equalTo(90)
            make.width.equalTo(45)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(100)
        }
        
        // 长按手势
        longPressGesture = UILongPressGestureRecognizer.init(target: self, action: .longPress)
        mapView.addGestureRecognizer(longPressGesture!)
        
        // 导航
        mapNaviMaskView.isHidden = true
        [mapNaviMaskView, mapNavigationView].forEach {
            view.addSubview($0)
        }
        
        mapNaviMaskView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        mapNaviMaskView.addGestureRecognizer(tapGesture)
    }
    
    
    
    // MARK: - Button Action
    
    func menuButtonTapped(_ sender: UIButton) {
        slideMenuController()?.toggleLeft()
    }
    
    func searchButtonTapped(_ sender: UIButton) {
        self.searchBarView.searchTextField.text = ""
        searchViewController.data = nil
        self.present(searchViewController, animated: false, completion: nil)
    }
    
    func locationButtonTapped(_ sender: UIButton) {
        if mapView.userTrackingMode != MAUserTrackingMode.follow {
            mapView.setUserTrackingMode(MAUserTrackingMode.follow, animated: true)
        }
    }
    
    func showNaviButtonTapped(_ sender: UIButton) {
        
        guard self.currentSelectState != 0 else {
            self.errorNotice("请选择目的地", autoClear: true)
            return
        }
        
        switch currentSelectState {
        case 1:
            // 当前是大头针选择模式
            setNaviEndPointWithPinAnnotation()
        case 2:
            // 当前是标记选择模式
            guard mapView.selectedAnnotations.count != 0 else {
                log("no annotation selected", .error)
                return
            }
            let annotation = mapView.selectedAnnotations[0]
            setNaviEndPoint(with: annotation as! MAPointAnnotation)
        default:
            break
        }
        
        // 将当前位置设置为naviStartPoint
        naviStartPoint.latitude = CGFloat((currentLocation?.coordinate.latitude)!)
        naviStartPoint.longitude = CGFloat((currentLocation?.coordinate.longitude)!)
        
        showNavigationView()
        //mapNavigationView.isEnabled = false
        let startPoints: [AMapNaviPoint] = [naviStartPoint]
        let endPoints: [AMapNaviPoint] = [naviEndPoint!]
        driveManager.calculateDriveRoute(withStart: startPoints, end: endPoints, wayPoints: nil, drivingStrategy: AMapNaviDrivingStrategy.singleDefault)
    }
    
    func speechButtonTapped(_ sender: UIButton) {
        log("hhh")
    }
    
    func navigationButtonTapped(_ sender: UIButton) {
        
        if driveView == nil {
            driveView = AMapNaviDriveView(frame: self.view.bounds)
            driveView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            driveView?.delegate = self
        }
        view.addSubview(driveView!)
        driveManager.addDataRepresentative(driveView!)
    }
    
    func closeNaviButtonTapped(_ sender: UIButton) {
        hiddenNavigationView()
    }
    
    // MARK: - Map Action
    
    /** 第一次进入地图进行定位*/
    func firstSetMapLocation() {
        mapView.setCenter((currentLocation?.coordinate)!, animated: true)
        mapView.setZoomLevel(15, animated: true)
        isFirstSetMapLocationDone = true
    }
    
    /** 清空地图标记*/
    func removeAnnotations() {
        guard annotations != nil else {
            return
        }
        
        mapView.removeAnnotations(annotations! as! [Any])
        if pinAnnotation != nil {
            mapView?.removeAnnotation(pinAnnotation)
            pinAnnotation = nil
        }
        annotations?.removeAllObjects()
    }
    
    /** 搜索本地*/
    func searchLocalAction(keywords: String) {
        removeAnnotations()
        
        let request = AMapPOIKeywordsSearchRequest()
        request.city = userCity
        request.keywords = keywords
        mapSearch.aMapPOIKeywordsSearch(request)
    }
    
    /** 搜索周边*/
    func searchAroundAction(keywords: String) {
        removeAnnotations()
        
        let request = AMapPOIAroundSearchRequest()
        request.location = AMapGeoPoint()
        request.location.latitude = CGFloat((currentLocation?.coordinate.latitude)!)
        request.location.longitude = CGFloat((currentLocation?.coordinate.longitude)!)
        request.keywords = keywords
        mapSearch.aMapPOIAroundSearch(request)
    }
    
    /** 长按放置大头针*/
    func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.began {
            let coordinate = mapView?.convert(gesture.location(in: mapView), toCoordinateFrom: mapView)
            
            // 添加标注
            if pinAnnotation != nil {
                // 清理
                mapView?.removeAnnotation(pinAnnotation)
                pinAnnotation = nil
            }
            
            pinAnnotation = MAPointAnnotation()
            pinAnnotation?.coordinate = coordinate!
            pinAnnotation!.title = "放置的大头针"
            
            mapView?.addAnnotation(pinAnnotation)
        }
    }
    
    /** POI搜索完成, 添加到地图上*/
    func poisSearchDone() {
        if isSpeechSearch {
            isSpeechSearch = false
        }else{
            searchViewController.data = pois
        }
        
        guard pois != nil else { return }
        
        for poi in pois!{
            let p = poi as! AMapPOI
            let annotation = MAPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(Double(p.location.latitude), Double(p.location.longitude))
            annotation.title = p.name
            annotation.subtitle = p.address
            
            annotations?.add(annotation)
            mapView?.addAnnotation(annotation)
        }
    }
    
    /** 利用annotation设置目的地*/
    func setNaviEndPoint(with annotation: MAPointAnnotation) {
        naviEndPoint = AMapNaviPoint()
        naviEndPoint?.latitude = CGFloat(annotation.coordinate.latitude)
        naviEndPoint?.longitude = CGFloat(annotation.coordinate.longitude)
        mapNavigationView.placeName = annotation.title
        mapNavigationView.placeLocation = annotation.subtitle
    }
    
    /** 利用pinAnnotation设置目的地*/
    func setNaviEndPointWithPinAnnotation() {
        guard let latitude = pinAnnotation?.coordinate.latitude,
            let longitude = pinAnnotation?.coordinate.longitude else{ return }
        
        naviEndPoint = AMapNaviPoint()
        naviEndPoint?.latitude = CGFloat(latitude)
        naviEndPoint?.longitude = CGFloat(longitude)
        mapNavigationView.placeName = "您所放置的大头针"
    }
    
    /** 清空目的地*/
    func clearNaviEndPoint() {
        naviEndPoint = nil
    }
    
    /** 显示navigationView*/
    func showNavigationView() {
        self.mapNaviMaskView.isHidden = false
        self.mapNaviMaskView.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.mapNaviMaskView.alpha += 0.4
            self.mapNavigationView.frame.origin.y -= 180
        }, completion: nil)
    }
    
    /** 隐藏navigationView*/
    func hiddenNavigationView() {
        self.mapNaviMaskView.isHidden = true
        self.mapNaviMaskView.alpha = 0.4
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.mapNaviMaskView.alpha -= 0.4
            self.mapNavigationView.frame.origin.y += 180
        }) { (isSucessDone) in
            self.mapNavigationView.clearText() // 清除text
        }
    }
    
    /** 退出navigationView并清空地图*/
    func quitNavigationView() {
        hiddenNavigationView()
        clearNaviEndPoint()
        removeAnnotations()
        searchBarView.searchTextField.text = ""
        
        pois = nil
        searchViewController.data = nil
    }
    
    // MARK: - Search Delegate
    
    func searchLocal(_ keyword: String) {
        log(keyword, .happy)
        searchBarView.searchTextField.text = keyword
        searchLocalAction(keywords: keyword)
    }
    
    func searchAround(_ keyword: String) {
        log(keyword, .happy)
        searchBarView.searchTextField.text = keyword
        searchAroundAction(keywords: keyword)
    }
    
    func selectResultRow(_ row: Int) {
        log(row, .happy)
        
        let annotation = annotations![row] as! MAPointAnnotation
        mapView.selectAnnotation(annotation, animated: true)
        mapView.setCenter((annotations![row] as AnyObject).coordinate, animated: true)
        mapView.setZoomLevel(15, animated: true)
        
    }
    
    
    // MARK: - Map Delegate
    
    /** 修改定位状态*/
    func mapView(_ mapView: MAMapView!, didChange mode: MAUserTrackingMode, animated: Bool) {
        if mode == MAUserTrackingMode.none {
            rightGroupButtonView.locationButton.setImage(#imageLiteral(resourceName: "main_btn_location"), for: .normal)
        } else {
            rightGroupButtonView.locationButton.setImage(#imageLiteral(resourceName: "main_btn_location_located"), for: .normal)
        }
    }
    
    /** 获取用户定位*/
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        guard userLocation != nil else { return }
        guard userLocation.location != nil else { return }
        
        currentLocation = userLocation.location.copy() as? CLLocation
        
        // 第一次初始化位置
        if !isFirstSetMapLocationDone { firstSetMapLocation() }
    }
    
    /** 选中annotation*/
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        // 选中了用户所在位置
        if view.annotation.isKind(of: MAUserLocation.self) {
            if (currentLocation != nil) {
                let request = AMapReGeocodeSearchRequest()
                request.location = AMapGeoPoint.location(withLatitude: CGFloat((currentLocation?.coordinate.latitude)!), longitude: CGFloat((currentLocation?.coordinate.longitude)!))
                mapSearch.aMapReGoecodeSearch(request)
            }
            return
        }
        // 选中了大头针
        if view.annotation.isEqual(pinAnnotation) {
            currentSelectState = 1
            setNaviEndPointWithPinAnnotation()
            return
        }
        // 选中了annotation
        if view.annotation.isKind(of: MAPointAnnotation.self) {
            currentSelectState = 2
            setNaviEndPoint(with: view.annotation as! MAPointAnnotation)
            return
        }
        
    }
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        guard !annotation.isKind(of: MAUserLocation.self) else { return nil}
        
        if annotation.isEqual(pinAnnotation) {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pinAnnotationReuseIdentifier) as? MAPinAnnotationView
            if annotationView == nil {
                annotationView = MAPinAnnotationView.init(annotation: annotation, reuseIdentifier: pinAnnotationReuseIdentifier)
            }
            
            annotationView?.canShowCallout = true
            annotationView?.animatesDrop = true
            
            return annotationView
        }
        
        if annotation.isKind(of: MAPointAnnotation.self) {
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationReuseIdentifier) as? CustomAnnotationView
            
            if annotationView == nil {
                annotationView = CustomAnnotationView.init(annotation: annotation, reuseIdentifier: annotationReuseIdentifier)
            }
            
            annotationView?.image = #imageLiteral(resourceName: "map_icon_annotation")
            
            annotationView?.layer.shadowOffset = CGSize(width: 0, height: 0)
            annotationView?.layer.shadowOpacity = 0.3
            annotationView?.layer.shadowRadius = 1
            
            annotationView?.canShowCallout = false
            
            // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
            annotationView?.centerOffset = CGPoint(x: 0, y: -18)
            
            return annotationView
        }
        return nil
    }
    
    /** 取消选中annotation*/
    func mapView(_ mapView: MAMapView!, didDeselect view: MAAnnotationView!) {
        log("取消选中")
        currentSelectState = 0
        clearNaviEndPoint()
    }
    
    // MARK: - Map Search Delegate
    
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        log("request :\(request), error: \(error)", .error)
    }
    
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        
        guard var title: NSString = response.regeocode.addressComponent.city as NSString? else {
            return
        }
        
        if (title.length == 0) {
            title = response.regeocode.addressComponent.province! as NSString
        }
        
        mapView?.userLocation.title = title as String
        mapView?.userLocation.subtitle = response.regeocode.formattedAddress
    }
    
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        if (response.pois.count > 0) {
            pois = response.pois! as NSArray
        }
    }
    
    // MARK: - Map Navi Delegate
    
    func driveManager(onCalculateRouteSuccess driveManager: AMapNaviDriveManager) {
        guard let time = driveManager.naviRoute?.routeTime,
            let distance = driveManager.naviRoute?.routeLength else {
                self.errorNotice("导航失败", autoClear: true)
                return
        }
        //mapNavigationView.isEnabled = true
        
        mapNavigationView.setTimeDistanceText(time: time, distance: Double(distance))
        
        driveManager.startGPSNavi()
    }
    
    // MARK: - Map Navi View Delegate
    
    func driveViewCloseButtonClicked(_ driveView: AMapNaviDriveView) {
        self.driveView?.isHidden = true
        self.driveView = nil
        quitNavigationView()
    }
}

extension MainViewController: CLLocationManagerDelegate {
    
    /** 获取用户当前城市*/
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(currentLocation!) { (placemarks, error) in
            guard let placemarks = placemarks else { return }
            if placemarks.count > 0 {
                let placemark = placemarks[0]
                if let city = placemark.locality {
                    userCity = city
                    self.locationManager.stopUpdatingLocation()
                }
            }
        }
    }
}

extension MainViewController: UIViewControllerTransitioningDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        bubbleTransition.transitionMode = .present
        bubbleTransition.startingPoint = speechButton.center
        bubbleTransition.bubbleColor = LJ.blueDefault
        return bubbleTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        bubbleTransition.transitionMode = .dismiss
        bubbleTransition.startingPoint = speechButton.center
        bubbleTransition.bubbleColor = LJ.blueDefault
        return bubbleTransition
    }

}


fileprivate extension Selector {
    static let showMenu = #selector(MainViewController.menuButtonTapped(_:))
    static let search = #selector(MainViewController.searchButtonTapped(_:))
    static let locate = #selector(MainViewController.locationButtonTapped(_:))
    static let showNavi = #selector(MainViewController.showNaviButtonTapped(_:))
    static let speech = #selector(MainViewController.speechButtonTapped(_:))
    static let longPress = #selector(MainViewController.handleLongPress(_:))
    static let navi = #selector(MainViewController.navigationButtonTapped(_:))
    static let closeNavi = #selector(MainViewController.closeNaviButtonTapped(_:))
}
