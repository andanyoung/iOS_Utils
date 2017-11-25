//
//  LoadingViewController.swift
//  UtilsDemo
//
//  Created by 安丹阳 on 2017/11/24.
//  Copyright © 2017年 an. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
     var loadingView: DYLoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadingView = DYLoadingView()
        loadingView.show(in: self.view, isCenter: true, loadType: .loading)
    }

    @IBAction func loadAction(_ sender: Any) {
        loadingView.loadingType = .loading
    }
    
    @IBAction func successAction(_ sender: Any) {
        
        loadingView.loadingType = .success
    }
    
    @IBAction func failureAction(_ sender: Any) {
        
        loadingView.loadingType = .failure
    }
    
}
