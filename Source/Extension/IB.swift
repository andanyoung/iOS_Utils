//
//  IB.swift
//  IB
//
//  Created by andy on 2016/12/3.
//  Copyright © 2016年 luxcon. All rights reserved.
//

import Foundation
import UIKit

//@IBDesignable
extension UIView{
    
    //inspectable 检查
    @IBInspectable var corerRadius : CGFloat {
        get{
            return self.layer.cornerRadius
        }
        set{
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var borderWidth : CGFloat{
        get{
            return self.layer.borderWidth
        }
        set{
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor : UIColor{
        get{
            return  UIColor(cgColor:  self.layer.borderColor!)
        }
        set{
            self.layer.borderColor = newValue.cgColor
        }
    }
    
}
