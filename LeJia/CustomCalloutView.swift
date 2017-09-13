//
//  CustomCalloutView.swift
//  MapTest
//
//  Created by 王嘉宁 on 16/3/29.
//  Copyright © 2016年 Jianing. All rights reserved.
//

import UIKit

let kArrorHeight = 10
let kPortraitMargin = 5
let kPortraitWidth = 70
let kPortraitHeight = 50
let kTitleWidth = 120
let kTitleHeight = 20

class CustomCalloutView: UIView {
    
    var image: UIImage?
    {
        didSet{
            self.setImage2(image: image!)
        }
    }
    var title: NSString?
        {
        didSet{
            self.setTitle2(title: title!)
        }
    }
    var subtitle: NSString?
    
        {
        didSet{
            self.setSubtitle2(subtitle: subtitle!)
        }
    }
    var portraitView: UIImageView?
    var subtitleLabel: UILabel?
    var titleLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initSubViews()
        self.backgroundColor = UIColor.clear
    }
    
    func initSubViews() {
        self.portraitView = UIImageView.init(frame: CGRect(x: CGFloat(kPortraitMargin), y: CGFloat(kPortraitMargin), width: CGFloat(kPortraitWidth), height: CGFloat(kPortraitHeight)))
        self.portraitView!.backgroundColor = UIColor.clear
        self.addSubview(self.portraitView!)
        
        // 添加标题
        self.titleLabel = UILabel.init(frame: CGRect(x: CGFloat(kPortraitMargin) * 2 + CGFloat(kPortraitWidth), y: CGFloat(kPortraitMargin), width: CGFloat(kTitleWidth), height: CGFloat(kTitleHeight)))
        self.titleLabel!.font = UIFont.boldSystemFont(ofSize: 14)
        self.titleLabel!.textColor = UIColor.white
        self.titleLabel!.text = "titletitletitletitle"
        self.addSubview(self.titleLabel!)
        
        self.subtitleLabel = UILabel.init(frame: CGRect(x: CGFloat(kPortraitMargin) * 2 + CGFloat(kPortraitWidth), y: CGFloat(kPortraitMargin) * 2 + CGFloat(kTitleHeight), width: CGFloat(kTitleWidth), height: CGFloat(kTitleHeight)))
        self.subtitleLabel!.font = UIFont.boldSystemFont(ofSize: 12)
        self.subtitleLabel!.textColor = UIColor.lightGray
        self.subtitleLabel!.text = "subtitlesubtitlesubtitlesubtitle"
        self.addSubview(self.subtitleLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    // MARK: - Override
    
    func setTitle2(title: NSString) {
        self.titleLabel?.text = title as String
    }
    
    func setSubtitle2(subtitle: NSString) {
        self.subtitleLabel?.text = subtitle as String
    }
    
    func setImage2(image: UIImage) {
        self.portraitView?.image = image
    }
    
    // MARK: - draw rect
    
    override func draw(_ rect: CGRect) {
        
        self.drawInContext(context: UIGraphicsGetCurrentContext()!)
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        
    }
    
    func drawInContext(context: CGContext) {
        context.setLineWidth(2.0)
        context.setFillColor(UIColor(colorLiteralRed: 0.3, green: 0.3, blue: 0.3, alpha: 0.8).cgColor)
        
        self.getDrawPath(context: context)
        context.fillPath()
    }
    
    func getDrawPath(context: CGContext) {
        let rrect = self.bounds
        let radius = 6.0
        let minx = rrect.minX
        let midx = rrect.midX
        let maxx = rrect.maxX
        let miny = rrect.minY
        let maxy = rrect.maxY - CGFloat(kArrorHeight)
        
        context.move(to: CGPoint(x: midx + CGFloat(kArrorHeight), y: maxy))
        context.move(to: CGPoint(x: midx, y: maxy + CGFloat(kArrorHeight)))
        context.move(to: CGPoint(x: midx - CGFloat(kArrorHeight), y: maxy))
        
        
        context.addArc(tangent1End: CGPoint(x: minx, y: maxy), tangent2End: CGPoint(x: minx, y: miny), radius: CGFloat(radius))
        context.addArc(tangent1End: CGPoint(x: minx, y: minx), tangent2End: CGPoint(x: maxx, y: miny), radius: CGFloat(radius))
        context.addArc(tangent1End: CGPoint(x: maxx, y: miny), tangent2End: CGPoint(x: maxx, y: maxx), radius: CGFloat(radius))
        context.addArc(tangent1End: CGPoint(x: maxx, y: maxy), tangent2End: CGPoint(x: midx, y: maxy), radius: CGFloat(radius))
        
        context.closePath()
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
