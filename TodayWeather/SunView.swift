//
//  SunView.swift
//  iWeathers
//
//  Created by pangfuli on 15/4/20.
//  Copyright (c) 2015年 pfl. All rights reserved.
//

import UIKit

class SunView: UIView {

    let ovalShapeLayer: CAShapeLayer = CAShapeLayer()
    let airplaneLayer: CALayer = CALayer()
    var startTime: String?
    var endTime: String?
    let radius: CGFloat = 50.0
    var baseLine: UIView?
    var finalAngle: CGFloat? = 0
    var temCenter: CGPoint = CGPoint(x: 110, y: 100)
    var aCenter: CGPoint?
    {
        didSet
        {
            self.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect)
    {
        super.init(frame:frame)
        self.backgroundColor = UIColor.clearColor()
    
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    override func drawRect(rect: CGRect) {
        
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 60, y: 100))
        path.addLineToPoint(CGPoint(x: frame.size.width/2, y: 100))
        path.addArcWithCenter(temCenter, radius: frame.size.width/4.0, startAngle: CGFloat(0), endAngle: CGFloat(M_PI), clockwise: false)

        UIColor.whiteColor().set()
        path.stroke()
        
    }

    
    func beginRefreshing() {
        
        let times = stringConvertNum(getNowTime()!)
        let endAngle =  convertToAngle(times) + CGFloat(M_PI)
        let path = UIBezierPath(arcCenter: temCenter, radius: radius, startAngle: CGFloat(M_PI), endAngle: endAngle, clockwise: true).CGPath
        ovalShapeLayer.path = path
        ovalShapeLayer.strokeColor = UIColor.whiteColor().CGColor
        ovalShapeLayer.fillColor = UIColor.clearColor().CGColor
        ovalShapeLayer.lineWidth = 4.0
        ovalShapeLayer.lineDashPattern = [2, 3]
        layer.addSublayer(ovalShapeLayer)
        
        
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = 0
        strokeStartAnimation.toValue = 1.0
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1.0
        
        let strokeAnimationGroup = CAAnimationGroup()
        strokeAnimationGroup.duration = 1.5
        
        strokeAnimationGroup.animations = [strokeStartAnimation, strokeEndAnimation]
        ovalShapeLayer.addAnimation(strokeAnimationGroup, forKey: nil)
        
    
        let airplaneImage = UIImage(named: "01d")!
        airplaneLayer.contents = airplaneImage.CGImage
        airplaneLayer.bounds = CGRect(x: 0.0, y: 0.0, width: airplaneImage.size.width/2, height: airplaneImage.size.height/2)
        airplaneLayer.position = CGPoint(x: 60, y: 100)
        layer.addSublayer(airplaneLayer)
        
        let flightAnimation = CAKeyframeAnimation(keyPath: "position")
        flightAnimation.path = path
        flightAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        
        let airplaneOrientationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        airplaneOrientationAnimation.fromValue = 0
        airplaneOrientationAnimation.toValue = 2 * M_PI
        
        let flightAnimationGroup = CAAnimationGroup()
        flightAnimationGroup.duration = 1.5
        flightAnimationGroup.fillMode = kCAFillModeForwards
        flightAnimationGroup.removedOnCompletion = false
        flightAnimationGroup.animations = [flightAnimation, airplaneOrientationAnimation]
        airplaneLayer.addAnimation(flightAnimationGroup, forKey: nil)

        airplaneLayer.position = CGPoint(x: cos(finalAngle! + CGFloat(M_PI)) * radius + temCenter.x, y: sin(finalAngle! + CGFloat(M_PI)) * radius + temCenter.y)
    }
    
  
    
    
    func getNowTime()->String?
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let dateStr = dateFormatter.stringFromDate(NSDate())
        
        return dateStr
        
    }
    
     func formatterDate(aDate:String)->NSTimeInterval?
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.dateFromString(aDate)
        let interval: NSTimeInterval = NSDate().timeIntervalSinceDate(date!)
        return interval
    }
    
     func formatterDateToNum(interval:NSTimeInterval)->CGFloat
    {
        let date = NSDate(timeInterval: interval, sinceDate: NSDate())
        let calender = NSCalendar(calendarIdentifier: NSCalendarIdentifierRepublicOfChina)
        let unitFlags = NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute
        let components = calender?.components(unitFlags, fromDate: date)
        let hour = CGFloat(components!.hour)
        let min = CGFloat(components!.minute)/60
        println(hour+min)
        return hour + min
    }
    
    
    func stringConvertNum(aString: String)->CGFloat
    {
        
        let arr = aString.componentsSeparatedByString(":") as NSArray
        let last = arr.lastObject as! String
        let first = arr.firstObject as! String
        let firstNum = first.toInt()
        let num = CGFloat(CGFloat(last.toInt()!)/60.0)
        
        return CGFloat(firstNum!) + num
    }
    
    
    func convertToAngle(times:CGFloat)->CGFloat
    {
        var start: CGFloat?
        var end: CGFloat?
        if let start_ = startTime
        {
            start = stringConvertNum(start_)
        }
        else
        {
            start = stringConvertNum("00:00")
        }
        
        if let end_ = endTime
        {
            end = stringConvertNum(end_)
        }
        else
        {
            end = stringConvertNum("24:00")
        }
        
        let sunrise = start!
        let sunset = end!
        
        finalAngle = acos((radius - (CGFloat(times - sunrise) / CGFloat(sunset - sunrise)*(radius*2)))/radius)
        
        if times > sunset
        {
            
            finalAngle = CGFloat(M_PI)
            
        }
        
        return  finalAngle!
    }
    
    override func didMoveToSuperview()
    {
        beginRefreshing()
    }

}




















