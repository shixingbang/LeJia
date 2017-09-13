//
//  Alamofire+LeJia.swift
//  LeJia
//
//  Created by 王嘉宁 on 2017/5/23.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import Foundation
import Alamofire

@objc public protocol ResponseObjectSerializable {
    init?(response: HTTPURLResponse, representation: AnyObject)
}

fileprivate let emptyDataStatusCodes: Set<Int> = [204, 205]

// 自定义响应序列化

extension Alamofire.Request {
    /**
     序列化图片
     - parameter response: 响应
     - parameter data: 数据
     - parameter error: 错误
     - returns: 图片
     */
    public static func serializeResponseImage(
        response: HTTPURLResponse?,
        data: Data?,
        error: Error?)
        -> Result<Any>
    {
        guard error == nil else { return .failure(error!) }
        
        if let response = response, emptyDataStatusCodes.contains(response.statusCode) { return .success(UIImage()) }
        
        guard let validData = data, validData.count > 0 else {
            return .failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
        }
        
        if let image = UIImage(data: data!) {
            return .success(image)
        } else {
            // 暂时用 inputDataNil 的错误来代替, 后期再改!
            return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
        }
    }
    

    
//    public static func imageSerializeResponse
    
//    public static func imageResponseSerializer() -> ResponseSerializer<UIImage, NSError> {
//        return ResponseSerializer { request, response, data, error in
//            guard error == nil else {
//                return .Failure(error!)
//            }
//            
//            guard let validData = data, validData.length > 0 else {
//                return .Failure(error!)
//            }
//            
//            let image = UIImage(data: data!)//, scale: UIScreen.mainScreen().scale)
//            
//            return .Success(image!)
//        }
//    }
//    
//    public func responseImage (_ completionHandler: @escaping (Response<UIImage>) -> Void) -> Self {
//        return response(responseSerializer: Request.serializeResponseImage(), completionHandler: completionHandler)
//    }

}

extension Alamofire.DataRequest {
    
    public static func imageResponseSerializer()
        -> DataResponseSerializer<Any>
    {
        return DataResponseSerializer { _, response, data, error in
            return Request.serializeResponseImage(response: response, data: data, error: error)
        }
    }
    
    @discardableResult
    public func responseImage(
        queue: DispatchQueue? = nil,
        completionHandler: @escaping (DataResponse<Any>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DataRequest.imageResponseSerializer(),
            completionHandler: completionHandler
        )
    }
}
