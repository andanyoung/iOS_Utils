//
//  LoadingViewController.swift
//  UtilsDemo
//
//  Created by 安丹阳 on 2017/11/24.
//  Copyright © 2017年 an. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    @IBOutlet weak var loadingView: DYLoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func loadAction(_ sender: Any) {
        loadingView.loading()
    }
    
    @IBAction func successAction(_ sender: Any) {
        
        loadingView.success()
    }
    
    @IBAction func failureAction(_ sender: Any) {
        
        loadingView.failure()
    }
    
}
