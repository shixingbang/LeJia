//
//  MusicViewController.swift
//  LeJia
//
//  Created by 石兴帮 on 2017/5/15.
//  Copyright © 2017年 乐驾. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation
import Kingfisher
import SnapKit

class MusicViewController: UIViewController, LJRoundPlayerViewDelegate, UITableViewDelegate, UITableViewDataSource, ChannelProtocol{

    
    // MARK: - Properties
    
    var coverImage: UIImageView!
    var playButton: LJPlayButton!
    var preButton: UIButton!
    var nextButton: UIButton!
    var roundPlayerView: LJRoundPlayerView!
    var tableView: UITableView!
    var songName: UILabel!
    var singerName: UILabel!
    var menuButton: UIButton!
    var channelButton: UIButton!
    var titleLabel: UILabel!
    var whiteView: UIView!
    var channelDic: Dictionary<String, String>!

    var channelViewController: ChannelViewController!
    
    // 接受频道的歌曲数据
    var tableData: [JSON]!
    {
        didSet {
            tableView.reloadData()
            onSelectRow(index: 0)
        }
    }
    
    var player = AVPlayer()
    
    var observer: AnyObject!
    var currentIndex = 0
    var isAutoFinish = true
    var order = 0
    
    // 第一次加载完成
    var didLoad = false

    /*
     *  ui
     */
    
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        createUI()
        
        getChannelData()
        getSongData(channel: "1")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Init UI
    
    func createUI () {
        
        initCoverImage()
        initRoundPlayerView()
        initTableView()
        initPreButton()
        initNextButton()
        initPlayButton()
        initMenuButton()
        initChannelButton()
        initTitleLabel()
        
        initSongLabel()
        initSingerLabel()
        initChannelViewController()
        initWaitCoverView()
    }
    
    func initCoverImage() {
        coverImage = UIImageView(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: 350))
//        coverImage.image = UIImage(named: "test_back")
        
        makeImageBlurry(imageView: coverImage)
        self.view.addSubview(coverImage)
    }

    func initRoundPlayerView() {
        roundPlayerView = LJRoundPlayerView(frame: CGRect.init(x: (self.view.bounds.width - 200) / 2, y: 100, width: 200, height: 200))
        roundPlayerView.coverImageView.image = UIImage(named: "test_back")
        roundPlayerView.delegate = self
        self.view.addSubview(roundPlayerView)
    }
    
    func initPlayButton() {
        playButton = LJPlayButton(frame: CGRect.init(x: (self.view.bounds.width - 76) / 2, y: 350 - 38, width: 76, height: 76), id: 0, normalImage: UIImage(named: "music_btn_play")!, tappedImage: UIImage(named: "music_btn_pause")!)
        playButton.addTarget(self, action: #selector(MusicViewController.buttonTapped(sender:)), for: UIControlEvents.touchUpInside)
        
        self.view.addSubview(playButton)
    }
    
    func initPreButton() {
        preButton = UIButton(frame: CGRect.init(x: 20, y: 187, width: 26, height: 26))
        preButton.setImage(UIImage(named: "music_btn_pre"), for: .normal)
        preButton.addTarget(self, action: #selector(MusicViewController.preButtonTapped), for: UIControlEvents.touchUpInside)
        self.view.addSubview(preButton)
    }
    
    func initNextButton() {
        nextButton = UIButton(frame: CGRect.init(x: self.view.bounds.width - 46, y: 187, width: 26, height: 26))
        nextButton.setImage(UIImage(named: "music_btn_next"), for: .normal)
        nextButton.addTarget(self, action: #selector(MusicViewController.nextButtonTapped), for: UIControlEvents.touchUpInside)
        self.view.addSubview(nextButton)
    }
    
    func initMenuButton() {
        menuButton = UIButton(frame: CGRect.init(x: 10, y: 30, width: 20, height: 20))
        menuButton.setImage(UIImage(named: "music_btn_menu"), for: .normal)
        menuButton.addTarget(self, action: #selector(MusicViewController.menuButtonTapped), for: .touchUpInside)
        self.view.addSubview(menuButton)
    }
    
    func initChannelButton() {
        channelButton = UIButton(frame: CGRect.init(x: self.view.bounds.width - 30, y: 30, width: 20, height: 20))
        channelButton.setImage(UIImage(named: "music_btn_channel"), for: .normal)
        channelButton.addTarget(self, action: #selector(MusicViewController.channelButtonTapped), for: .touchUpInside)
        self.view.addSubview(channelButton)
    }
    
    func initTitleLabel() {
        titleLabel = UILabel(frame: CGRect.init(x: (self.view.bounds.width - 50) / 2, y: 20, width: 50, height: 25))
        titleLabel.font = UIFont(name: "Helvetica", size: 18)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.text = "Music"
        self.view.addSubview(titleLabel)
    }
    
    func initTableView() {
        tableView = UITableView(frame: CGRect.init(x: 0, y: 350, width: self.view.bounds.width, height: self.view.bounds.height - 350))
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        //tableView.register(UINib(nibName: "MusicSongTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "musicSongCell")
        tableView.register(MusicSongTableViewCell.classForCoder(), forCellReuseIdentifier: "musicSongCell")
        tableView.reloadData()
        tableView.rowHeight = 80
    }
    
    func initSongLabel() {
        songName = UILabel(frame: CGRect.init(x: 0, y: 45, width: self.view.bounds.width, height: 20))
        songName.font = UIFont(name: "Helvetica", size: 16)
        songName.text = "Song"
        songName.textColor =  UIColor.white
        songName.textAlignment = .center
        self.view.addSubview(songName)
    }
    
    func initSingerLabel() {
        singerName = UILabel(frame: CGRect.init(x: 0, y: 65, width: self.view.bounds.width, height: 20))
        singerName.font = UIFont(name: "Helvetica", size: 14)
        singerName.text = "SingerName"
        singerName.textColor =  UIColor.white
        singerName.textAlignment = .center
        self.view.addSubview(singerName)
    }
    
    func initChannelViewController() {
        channelViewController = ChannelViewController()
        channelViewController.createUI()
        channelViewController.delegate = self
    }
    
    func initWaitCoverView() {
//        whiteView = UIView(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
//        whiteView.backgroundColor = UIColor.white
//        self.view.addSubview(whiteView)
//        var imagesArray = Array<UIImage>()
//        self.pleaseWait()
//        self.clearAllNotice()
 //       for i in 1...7 {
   //         imagesArray.append(UIImage(named: "loading\(i)")!)
     //   }
       // self.pleaseWaitWithImages(imagesArray, timeInterval: 50)
    }

    
    func getChannelData() {

        channelDic = ["1": "新歌榜" ,"2": "热歌榜","11": "摇滚榜","12": "爵士","16": "流行","21": "欧美金曲榜","22": "经典老歌榜","23": "情歌对唱榜","24": "影视金曲榜","25": "网络歌曲榜"]
    }
    
    func getSongData(channel: String) {
//        Alamofire.request("https://douban.fm/j/mine/playlist?type=n&channel=\(channel)&from=mainsite").responseJSON { response in
        Alamofire.request("http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.billboard.billList&type=\(channel)&size=10&offset=0").responseJSON { response in
                if let value = response.result.value {
                    let json = JSON(value)
                    let sData = json["song_list"].array

                    self.tableData = sData
            }
        }
    }
    
    
    // MARK: - Button Action
    
    func buttonTapped(sender: LJPlayButton) {
        sender.onClick()
        if sender.isTapped {
            print("1 tapped pause")
            self.roundPlayerView.start()
            self.player.play()
        }else{
            print("1 untapped play")
            self.roundPlayerView.stop()
            self.player.pause()
        }
    }

    func preButtonTapped() {
        isAutoFinish = false
        switch order {
        case 0:
            currentIndex -= 1
            if currentIndex < 0 {
                currentIndex = self.tableData.count - 1
            }
            onSelectRow(index: currentIndex)
        case 1:
            currentIndex = Int.init(arc4random()) % tableData.count
            onSelectRow(index: currentIndex)
        case 2:
            onSelectRow(index: currentIndex)
        default:
            print("")
        }
        
    }
    
    func nextButtonTapped() {
        isAutoFinish = false
        switch order {
        case 0:
            currentIndex += 1
            if currentIndex > self.tableData.count - 1 {
                currentIndex = 0
            }
            onSelectRow(index: currentIndex)
        case 1:
            currentIndex = Int.init(arc4random()) % tableData.count
            onSelectRow(index: currentIndex)
        case 2:
            onSelectRow(index: currentIndex)
        default:
            print("")
        }
    }
    
    func channelButtonTapped() {
        channelViewController.channelDic = self.channelDic
        self.present(channelViewController, animated: true, completion: nil)
    }
    
    func menuButtonTapped() {
        slideMenuController()?.toggleLeft()
    }

    // MARK: - Channel Delegate
    
    func onChangeChannel(channel_id: String) {
        getSongData(channel: channel_id)
    }

    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableData == nil {
            return 0
        }else{
            return tableData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "musicSongCell", for: indexPath) as! MusicSongTableViewCell
       // cell.request?.cancel()
        
        let rowData = self.tableData[indexPath.row]
        let url = rowData["pic_small"].string
        
        cell.titleLabel.text = rowData["title"].string
        cell.artistLabel.text = rowData["artist_name"].string
        
        cell.songImageView.kf.setImage(with: URL.init(string: url!))
        cell.songImageView.contentMode = .scaleAspectFit
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isAutoFinish = false
        onSelectRow(index: indexPath.row)
    }

    
    // MARK: - Tool
    
    func makeImageBlurry(imageView : UIImageView){
        
        //only apply the blur if the user hasn't disabled transparency effects
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = imageView.bounds
            blurEffectView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
            
            imageView.addSubview(blurEffectView)
            
        }
    }

    func onSelectRow(index:Int) {
        let indexPath = IndexPath.init(row: index, section: 0)
        // 选中的效果
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.top)
        
        let rowData = self.tableData[indexPath.row]
        self.songName.text = rowData["title"].string
        self.singerName.text = rowData["artist_name"].string
        let imgUrl = rowData["pic_small"].string!
        onSetImage(url: imgUrl)
        
        var audioUrl = ""
        let songId = rowData["song_id"].string!
        Alamofire.request("http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.song.play&songid=\(songId)").responseJSON { response in
            if let value = response.result.value {
                let json = JSON(value)
                audioUrl = json["bitrate"]["show_link"].string!
                
                self.onSetAudio(url: audioUrl)
            }
        }
        
        currentIndex = index
    }

    // 设置歌曲封面图
    func onSetImage(url: String) {
        
        print(url)
        
        self.coverImage.kf.setImage(with: URL.init(string: url))
        self.roundPlayerView.coverImageView.kf.setImage(with: URL.init(string: url))
    }
    
    // 播放歌曲
    func onSetAudio(url: String) {
        self.roundPlayerView.reset()
        
        self.player.pause()
        let nsurl = NSURL(string: url)
        self.player.replaceCurrentItem(with: AVPlayerItem.init(url: nsurl! as URL ))
        self.player.play()
        playButton.setClick()
        // 播放结束通知
        NotificationCenter.default.addObserver(self, selector: #selector(MusicViewController.playFinish), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        observer = self.player.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 10), queue: nil) { t in
            if Double((self.player.currentItem?.duration.value)!) > 0 {
                if !self.didLoad {
                    self.clearAllNotice()
//                    self.whiteView.isHidden = true
                    self.didLoad = true
                }
                self.setDuration()
            }
        } as AnyObject
    }
    
    func setDuration() {
        let d = Double((self.player.currentItem?.duration.value)!)
        let a = Double((self.player.currentItem?.duration.timescale)!)
        print(Double(d / a))
        self.roundPlayerView.restartWithProgress(duration: Double(d / a))
        self.player.removeTimeObserver(observer)
        
//        do {
//            try self.player.removeTimeObserver(observer)
//        }
    }

    // 图片缓存
    func onGetCacheImage(url:String, imageView: UIImageView) {
        
        self.coverImage.kf.setImage(with: url as? Resource)
        
    }
    
    func playFinish() {
        if isAutoFinish {
            switch order {
            case 0:
                currentIndex += 1
                if currentIndex > self.tableData.count - 1 {
                    currentIndex = 0
                }
                onSelectRow(index: currentIndex)
            case 1:
                currentIndex = Int.init(arc4random()) % tableData.count
                onSelectRow(index: currentIndex)
            case 2:
                onSelectRow(index: currentIndex)
            default:
                print("")
            }
            
        }else{
            isAutoFinish = true
        }
    }

    
    // MARK: - JNRoundPlayer Delegate
    
    func controlButtonTapped(index: Int, state: String) {
        switch index {
        case 0:
            if state == "tapped" {
                order = 1
            }else{
                order = 0
            }
        case 1:
            if state == "tapped" {
                print("like")
            }else{
                print("unlike")
            }
        case 2:
            if state == "tapped" {
                order = 2
            }else{
                order = 0
            }
        default:
            print("nothing")
        }
    }

}
