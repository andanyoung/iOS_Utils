//
//  Color.swift
//  MCVoice
//
//  Created by andy on 2017/1/6.
//  Copyright © 2017年 luxcon. All rights reserved.
//

import UIKit

extension UIColor{
    
    class func dy_255(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1)-> UIColor {
        
        return UIColor(red: red /  255.0, green: green /  255.0, blue: blue /  255.0, alpha: alpha)
    }
    
   class func dy_hex(hex: Int, alpha: CGFloat = 1)-> UIColor {
        
        return UIColor.dy_255(red: CGFloat((hex & 0xFF0000) >> 16 ), green: CGFloat((hex & 0x00FF00) >> 8 ), blue: CGFloat((hex & 0xFF) ), alpha: alpha)
    }
}
