//
//  UIVIew.swift
//  healthy
//
//  Created by andy on 2017/4/21.
//  Copyright © 2017年 massagechair. All rights reserved.
//

import UIKit
//import CoreGraphics

extension UIView {

    @discardableResult
    func dy_width(_ width: CGFloat) -> UIView {
        
        self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: width, height: bounds.height))
        return self
    }
    
    @discardableResult
    func dy_height(_ height: CGFloat) -> UIView {
        
        self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: bounds.width, height: height))
        return self
    }
    
    @discardableResult
    func dy_x( _ x: CGFloat) -> UIView {
    
        self.frame =  CGRect(x: x, y: frame.minY, width: bounds.width, height: bounds.height)
        return self
    }
    
    @discardableResult
    func dy_y( _ y: CGFloat) -> UIView {
        
        self.frame =  CGRect(x: frame.minX, y: y, width: bounds.width, height: bounds.height)
        return self
    }
}


protocol Shakeable { }

extension Shakeable where Self: UIView {
    
    func shake() {
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: self.center.x - 4.0, y: self.center.y)
        animation.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
        layer.add(animation, forKey: "position")
    }
}


protocol Circleable {
    
    func setCircle( _ isCircle: Bool )
}

extension Circleable where Self: UIView{
    
    func setCircle(_ isCircle: Bool = true){
        
        self.layer.cornerRadius = self.bounds.width / 2.0
        self.layer.masksToBounds = true
    }
}

extension UIImageView: Circleable{ }

extension UIButton: Circleable { }

