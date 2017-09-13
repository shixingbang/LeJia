//
//  String+SecureLogon.swift
//  SecureLogon
//
//  Created by 王嘉宁 on 2017/5/3.
//  Copyright © 2017年 SDCA. All rights reserved.
//

import Foundation

extension String {
    /**
     Get the MD5 hash of this String
     
     - returns: MD5 hash of this String
     */
    func md5() -> String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLength = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLength)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        
        for i in 0..<digestLength {
            hash.appendFormat("%02x", result[i])
        }
        
        result.deinitialize()
        
        return String(format: hash as String)
    }
}
