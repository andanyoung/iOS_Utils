//
//  CAAnimation.swift
//  UtilsDemo
//
//  Created by 安丹阳 on 2017/11/25.
//  Copyright © 2017年 an. All rights reserved.
//

import UIKit


/// - CABasicAnimation 为强引用 设置debugDelegate 防止内存泄漏
extension CABasicAnimation: CAAnimationDelegate{
    
    fileprivate struct CAAssociatedKeys {
        static var DelegateBasicAnimationKey = "MyBasicAnimationKey"
//        static var CABasicAnimationKey = "CABasicAnimationKey"
    }
    
    override open var delegate: CAAnimationDelegate? {
        
        get{
            return super.delegate
        }
        set{
            super.delegate = newValue
            guard  let delegate =  newValue as? CABasicAnimation,
                delegate == self else{
                objc_setAssociatedObject(self,  &CAAssociatedKeys.DelegateBasicAnimationKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
                    return
            }
        }
    }
    
    
    var debugDeleagte: CAAnimationDelegate? {
        
        get{
            guard let delegate = objc_getAssociatedObject(self, &CAAssociatedKeys.DelegateBasicAnimationKey) as? CAAnimationDelegate else { return nil }
            
            return delegate
        }
        
        set{
            self.delegate = self
            objc_setAssociatedObject(self,  &CAAssociatedKeys.DelegateBasicAnimationKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    public func animationDidStart(_ anim: CAAnimation){
        
        debugDeleagte?.animationDidStart?(anim)
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        debugDeleagte?.animationDidStop?(anim, finished: flag)
        self.delegate = nil
    }
    
}
