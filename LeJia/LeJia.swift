//
//  LeJia.swift
//  LeJia
//
//  Created by 王嘉宁 on 2017/5/13.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import Foundation
import UIKit

/** 全局变量*/
struct LJ {
    
    static let base_url = "http://139.199.38.207:8000"
    /// 高德 Key
    static let AMapAPIKey = "21092ce9e586a9c00fd1f78bb829f25b"
    /// 限行 Kay
    static let TrafficRestrictionAPIKey = "d1f31f230fff8af0fe5f97fefdd8a4c0"
    /// 讯飞 Key
    static let IFlyAPIKey = "appid=5916e849"
    
    // MARK: - 颜色配置
    
    /** 默认背景灰色*/
    static var grayDefault: UIColor {
        return UIColor.customColor(red: 239, green: 239, blue: 244, alpha: 1)
    }
    
    /** 默认分割线颜色*/
    static var grayLine: UIColor {
        return UIColor.customColor(red: 0, green: 0, blue: 0, alpha: 0.2)
    }
    
    /** 轻灰色搜索条*/
    static var grayLightSearch: UIColor {
        return UIColor.customColor(red: 220, green: 218, blue: 213, alpha: 1)
    }
    
    /** 轻灰色搜索条字体*/
    static var grayLightSearchFont: UIColor {
        return UIColor.customColor(red: 0, green: 0, blue: 0, alpha: 0.4)
    }
    
    /** 默认蓝色*/
    static var blueDefault: UIColor {
        return UIColor.customColor(red: 0, green: 122, blue: 255, alpha: 1)
    }
    
    /** 搜索界面白黄*/
    static var whiteYellow: UIColor {
        return UIColor.customColor(red: 248, green: 247, blue: 244, alpha: 1)
    }
    
    /** 默认红色, 登录注册页面按钮红色*/
    static var redDefault: UIColor {
        return UIColor.customColor(red: 255, green: 51, blue: 102, alpha: 1)
    }
    
    /** 默认绿色, 状态栏通知*/
    static var greenDefault: UIColor {
        return UIColor.customColor(red: 83, green: 215, blue: 105, alpha: 1)
    }
    
    /** 默认紫色, 导航栏颜色*/
    static var purpleDefault: UIColor {
        return UIColor.customColor(red: 48, green: 36, blue: 94, alpha: 1)
    }
    
    static var greenWeChat: UIColor {
        return UIColor.customColor(red: 143, green: 202, blue: 47, alpha: 1)
    }
    
    /** cell紫色*/
    static var cellPurple: UIColor {
        return UIColor.customColor(red: 89, green: 74, blue: 155, alpha: 1)
    }
    
    /** cell绿色*/
    static var cellGreen: UIColor {
        return UIColor.customColor(red: 81, green: 163, blue: 58, alpha: 1)
    }
    
    /** cell橘色*/
    static var cellOrange: UIColor {
        return UIColor.customColor(red: 234, green: 88, blue: 63, alpha: 1)
    }
    
    /** cell黄色*/
    static var cellYellow: UIColor {
        return UIColor.customColor(red: 247, green: 171, blue: 23, alpha: 1)
    }
    
    /** cell颜色组*/
    static var cellColors: [UIColor] {
        return [cellPurple, cellGreen, cellYellow, cellOrange]
    }
    
    // MARK: - 屏幕尺寸相关
    
    /** 侧滑菜单宽度*/
    static var leftMenuWidth: CGFloat {
        return 280
    }
    
    /** 屏幕宽度*/
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    /** 屏幕高度*/
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    /** 屏幕尺寸*/
    static var screenSize: CGSize {
        return UIScreen.main.bounds.size
    }
    
    /** 全屏*/
    static var screenFrame: CGRect {
        return CGRect(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight)
    }
    
    /** 默认控件高度*/
    static let controlsHeight: CGFloat = 40
    
    /** 控件之间的边距 iPhone6 margin = 60; iPhone5s margin = 50*/
    static let controlsMargin: CGFloat = {
        //568 667
        guard LJ.screenHeight > 600 else {
            return CGFloat(LJ.controlsHeight + 10)
        }
        return CGFloat(LJ.controlsHeight + 20)
    }()
    
    /** 导航栏44+状态栏20高度*/
    static let navigationBarHeight: CGFloat = 64
    
    
    /// 用户词
    static let userwords = "{\"userword\":[{\"name\":\"我的常用词\",\"words\":[\"乐驾生活\",\"预约加油\",\"音乐电台\",\"中心校区\",\"洪家楼校区\",\"千佛山校区\",\"洪家楼\",\"预约\",\"限行\",\"罚\"]},{\"name\":\"我的好友\",\"words\":[\"王嘉宁\",\"姚懿容\",\"石兴帮\",\"赵一帆\"]}]}"
    
    static let logoNameDic = ["奥迪": "aodi", "宝马": "baoma", "保时捷": "baoshijie", "奔驰": "benchi", "本田": "bentian", "标致": "biaozhi", "别克": "bieke", "比亚迪": "biyadi", "长安": "changan", "长城": "changcheng", "大众": "dazhong", "法拉利": "falali", "丰田": "fengtian", "福特": "fute", "红旗": "hongqi", "马自达": "mazida", "奇瑞": "qirui", "起亚": "qiya", "日产": "richan", "神龙": "shenlong", "现代": "xiandai", "一汽": "yiqi"]
}
