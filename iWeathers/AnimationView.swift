//
//  AnimationView.swift
//  OfficeBuddy
//
//  Created by pfl on 15/4/13.
//  Copyright (c) 2015年 pangfuli. All rights reserved.
//

import UIKit

class AnimationView: UIView {

    
    override init(frame:CGRect)
    {
        super.init(frame:frame)
        let label = UILabel(frame: frame)
        label.text = "加载中..."
        label.font = UIFont.systemFontOfSize(10)
        label.textAlignment = NSTextAlignment.Center
        self.addSubview(label)
        self.backgroundColor = UIColor.clearColor()
        self.animation1()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawRect(rect: CGRect) {
       
    }

    class func startAnimation()
    {
//         AnimationView.animation1()
    }
    
    
     func animation1()
    {
        
        let rep = CAReplicatorLayer()
        rep.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        rep.cornerRadius = 10
        rep.position = self.center
        self.layer.addSublayer(rep)
        
        
        let dot = CALayer()
        dot.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
        dot.position = CGPoint(x: 90, y: 40)
        dot.cornerRadius = 5.0
        dot.borderColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0).CGColor
        dot.backgroundColor = dot.borderColor
        dot.borderWidth = 1
        dot.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
        rep.addSublayer(dot)
        
        let nrDots: Int = 15
        rep.instanceCount = nrDots
        let angle = CGFloat(2 * M_PI) / CGFloat(nrDots)
        rep.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1.0)
        
        let duration: CFTimeInterval = 1.5
        let shrink = CABasicAnimation(keyPath: "transform.scale")
        shrink.fromValue = 1.0
        shrink.toValue = 0.1
        shrink.duration = duration
        shrink.repeatCount = HUGE
        dot.addAnimation(shrink, forKey: nil)
        rep.instanceDelay = duration / CFTimeInterval(nrDots)
    
       
    }

}
