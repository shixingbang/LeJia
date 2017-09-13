//
//  LJPlayButton.swift
//  LeJia
//
//  Created by SXB on 2017/5/17.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import UIKit

class LJPlayButton: UIButton {

    // MARK: - Properties
    
    private var normalImage: UIImage!
    private var tappedImage: UIImage!
    private var ID: Int!
    
    var isTapped: Bool = false
    
    init(frame: CGRect, id: Int, normalImage: UIImage, tappedImage: UIImage) {
        super.init(frame: frame)
        self.ID = id
        self.normalImage = normalImage
        self.tappedImage = tappedImage
        self.setImage(normalImage, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setter
    
    func onClick() {
        isTapped = !isTapped
        if isTapped {
            self.setImage(tappedImage, for: .normal)
        } else {
            self.setImage(normalImage, for: .normal)
        }
    }
    
    func id() -> Int {
        return self.ID
    }
    
    func setClick() {
        isTapped = true
        self.setImage(tappedImage, for: .normal)
    }
    
    func setUnClick() {
        isTapped = false
        self.setImage(normalImage, for: .normal)
    }
}
