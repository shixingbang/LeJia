//
//  CustomAnnotationView.swift
//  MapTest
//
//  Created by 王嘉宁 on 16/3/29.
//  Copyright © 2016年 Jianing. All rights reserved.
//

import UIKit

let kCalloutWidth = 200.0
let kCalloutHeight = 70.0

var isSelectAnnotationView = false
var annotationViewSelectedLongitude = CGFloat(0)
var annotationViewSelectedLatitude = CGFloat(0)
var annotationViewSelectedTitle = ""

class CustomAnnotationView: MAAnnotationView {
    
    var calloutView: CustomCalloutView?

    
    // MARK: - Override
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if self.isSelected == selected {
            return
        }
        
        if selected {
            isSelectAnnotationView = true
            annotationViewSelectedLatitude = CGFloat(self.annotation.coordinate.latitude)
            annotationViewSelectedLongitude = CGFloat(self.annotation.coordinate.longitude)
            annotationViewSelectedTitle = self.annotation.title!
            
            if  self.calloutView == nil {
                self.calloutView = CustomCalloutView(frame: CGRect(x: 0, y: 0, width: CGFloat(kCalloutWidth), height: CGFloat(kCalloutHeight)))
                self.calloutView?.center = CGPoint(x: self.bounds.width / 2.0 + self.calloutOffset.x, y: -(self.calloutView?.bounds)!.height / 2.0 + self.calloutOffset.y)
            }
            
            self.calloutView?.image = UIImage(named: "map_icon_calloutView")
            self.calloutView?.title = self.annotation.title!! as NSString
            self.calloutView?.subtitle  = self.annotation.subtitle!! as NSString
            
            self.addSubview(self.calloutView!)
        }else{
            self.calloutView?.removeFromSuperview()
        }
        
        super.setSelected(selected, animated: animated)
    }
    
    // ???? 不起作用
    // 重写此函数，用以实现点击calloutView判断为点击该annotationView
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var inside = super.point(inside: point, with: event)
        if (!inside && self.isSelected) {
            inside = (self.calloutView?.point(inside: self.convert(point, to: self.calloutView), with: event))!
        }
        return inside
    }
}
