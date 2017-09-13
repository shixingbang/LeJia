//
//  ViewController.swift
//  LeJia
//
//  Created by 王嘉宁 on 2017/5/8.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Property
    
    /** hhhh */
    var myProperty: String = "example"
    /// hello
    var myProperty2: Int = 1
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action
    
    /**
     Connects two String
     - parameter para1: first para
     - parameter para2: seconde para
     - note: balabala
     - returns: the created JSON object
     */
    func myFunc(para1: String, para2: String) -> String{
        let result = para1 + para2
        return result
    }
    
    /**
     asfd
     - parameter lll: lasdjf
     - note: slkdjfl
     - returns: lasdlf
     */
    func testComment(para1: String) -> String {
        return para1 + "😃"
    }
    
    // MARK: - 1
    func myInit() {
        
    }
    
    // TODO: - balabala
    func myTodo() {
        
    }
    
    // FIXME: - fixme
    func myFix() {
        
    }
    
    
    
}

