//
//  Example2ViewController.swift
//  LeJia
//
//  Created by 王嘉宁 on 2017/5/13.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import UIKit
import SnapKit

class Example12ViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var myView: UIView = {
        let v = UIView()
        return v
    }()
    
    lazy var button: UIButton = { [unowned self] in
        let b = UIButton()
        b.addTarget(self, action: .tap, for: .touchUpInside)
        return b
    }()
    
    // MARK: - Lifecycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray
        self.navigationItem.title = "Example"
        initUI()
    }
    
    deinit {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Init
    
    func initUI() {
        [myView, button].forEach {
            view.addSubview($0)
        }
        myView.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-40)
            make.top.equalToSuperview().offset(80)
        }
        
        button.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-40)
            make.top.equalToSuperview().offset(80)
        }
        
    }
    
    // MARK: - Button Action
    
    func buttonTapped(_ sender: UIButton) {
        
    }
    
}

fileprivate extension Selector {
    static let tap = #selector(Example12ViewController.buttonTapped(_:))
}
