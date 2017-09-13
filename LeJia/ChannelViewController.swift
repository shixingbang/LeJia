//
//  ChannelViewController.swift
//  LeJia
//
//  Created by 石兴帮 on 2017/5/17.
//  Copyright © 2017年 乐驾. All rights reserved.
//

import UIKit

protocol ChannelProtocol {
    func onChangeChannel (channel_id: String)
}

class ChannelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    // 遵循ChannelProtocol协议的代理
    var delegate: ChannelProtocol?
    
    // 频道列表数据
    var channelDic = ["1": "新歌榜" ,"2": "热歌榜","11": "摇滚榜","12": "爵士","16": "流行","21": "欧美金曲榜","22": "经典老歌榜","23": "情歌对唱榜","24": "影视金曲榜","25": "网络歌曲榜"]
    var channelData: NSMutableArray = []
    var channelType: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for (key, value) in channelDic {
            channelType.add(key)
            channelData.add(value)
        }
        
        createUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createUI() {
        initTableView()
    }
    
    func initTableView() {
        tableView = UITableView(frame: self.view.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }
    
    // 处理点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let rowData = self.channelData[indexPath.row]
//        let channel_id = rowData["channel_id"].string
        let channel_id = channelType[indexPath.item]
        delegate?.onChangeChannel(channel_id: channel_id as! String)
        // 关闭当前界面
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelDic.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "channel")
//        let rowData = self.channelData[indexPath.row]
//        cell.textLabel?.text = rowData["name"].string
        cell.textLabel?.text = channelData[indexPath.item] as? String
        return cell
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
