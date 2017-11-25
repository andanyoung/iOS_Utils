//
//  UIImage.swift
//  healthy
//
//  Created by 安丹阳 on 2017/5/25.
//  Copyright © 2017年 massagechair. All rights reserved.
//

import UIKit

extension UIImage{
    
    //生成圆形图片
    func toCircle() -> UIImage {
        //取最短边长
        let shotest = min(self.size.width, self.size.height)
        //输出尺寸
        let outputRect = CGRect(x: 0, y: 0, width: shotest, height: shotest)
        //开始图片处理上下文（由于输出的图不会进行缩放，所以缩放因子等于屏幕的scale即可）
        UIGraphicsBeginImageContextWithOptions(outputRect.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        //添加圆形裁剪区域
        context.addEllipse(in: outputRect)
        context.clip()
        //绘制图片
        self.draw(in: CGRect(x: (shotest-self.size.width)/2,
                             y: (shotest-self.size.height)/2,
                             width: self.size.width,
                             height: self.size.height))
        //获得处理后的图片
        let maskedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return maskedImage
    }
    
    //调整图片像素
    func zoom(_ bounds: CGSize, isCircle: Bool = false) -> UIImage?{
        
        UIGraphicsBeginImageContextWithOptions(bounds, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        //添加圆形裁剪区域
        context.addEllipse(in: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
        context.clip()
        self.draw(in: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}



