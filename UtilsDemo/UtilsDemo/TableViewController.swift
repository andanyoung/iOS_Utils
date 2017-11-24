//
//  TableViewController.swift
//  UtilsDemo
//
//  Created by 安丹阳 on 2017/11/23.
//  Copyright © 2017年 an. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0{
                let _ = WebViewController.open("http://www.baidu.com", title: "test WebViewController")
            }else if indexPath.row == 1 {
                
//                let radius: CGFloat = 40
//                let vc = UIViewController()
//                vc.view.bounds = UIScreen.main.bounds
//                vc.view.backgroundColor = .white
//                let loadView = DYLoadingView(frame: CGRect(x: vc.view.center.x - radius, y: vc.view.center.y - radius, width: radius * 2, height: radius * 2))
//                vc.view.addSubview(loadView)
//
//                loadView.loading()
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5, execute: {
//
//                    loadView.failure()
//                })
//
//                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }

}
