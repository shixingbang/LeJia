//
//  WebViewController.swift
//  LeJia
//
//  Created by 王嘉宁 on 2017/5/31.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    var urlString: String
    var naviTitle: String
    
    lazy var webView: UIWebView = {
        let w = UIWebView()
        return w
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = naviTitle
        
        self.view.addSubview(webView)
        
        webView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let url = URL(string: urlString)
        let request = URLRequest(url: url!);
        webView.loadRequest(request);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    init(url: String, title: String = "") {
        self.urlString = url
        self.naviTitle = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
