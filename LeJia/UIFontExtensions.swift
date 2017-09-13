//
//  UIFontExtension.swift
//  SecureLogon
//
//  Created by 王嘉宁 on 2017/4/13.
//  Copyright © 2017年 SDCA. All rights reserved.
//

import UIKit

extension UIFont {
    
    static var defaultFont: UIFont {
        return UIFont(name: "Helvetica", size: 13)!
    }
    
    static func defaultFont(size: Int) -> UIFont? {
        guard size > 0 else {
            return nil
        }
        return UIFont(name: "Helvetica", size: 13)!
    }
}
