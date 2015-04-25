//
//  CenterScrollView.swift
//  OfficeBuddy
//
//  Created by pfl on 15/4/14.
//  Copyright (c) 2015年 pangfuli. All rights reserved.
//

import UIKit

class CenterScrollView: UIScrollView {

    var label: UILabel!
    var label2: UILabel!
    var imageView: UIImageView!
  
    @IBOutlet weak var temp: UILabel!
        {
        didSet{
            temp.text = "20°C"
            temp.textColor = UIColor.whiteColor()
            temp.font = UIFont.systemFontOfSize(30)
            temp.textAlignment = NSTextAlignment.Center
        }
    }
    @IBOutlet weak var weatherIcon: UIImageView!
        {
        didSet{
            
            weatherIcon.image = UIImage(named: "sunny")
            
        }
    }
    @IBOutlet weak var symbol: UILabel!
        {
        didSet
        {
            symbol.font = UIFont.boldSystemFontOfSize(10)
            symbol.textColor = UIColor.whiteColor()
            
        }
    }
    @IBOutlet weak var grndLevel: UILabel!
        {
        didSet
        {
            grndLevel.textColor = UIColor.whiteColor()
            grndLevel.font = UIFont.boldSystemFontOfSize(10)
        }
    }
    @IBOutlet weak var sea_level: UILabel!
        {
        didSet
        {
            sea_level.textColor = grndLevel.textColor
            sea_level.font = grndLevel.font
        }
    }
    @IBOutlet weak var humidity: UILabel!
        {
        didSet
        {
            humidity.textColor = grndLevel.textColor
            humidity.font = grndLevel.font
        }
    }
    @IBOutlet weak var pressure: UILabel!
        {
        didSet
        {
            pressure.textColor = grndLevel.textColor
            pressure.font = grndLevel.font
        }
    }
    @IBOutlet weak var temp_max: UILabel!
        {
        didSet
        {
            temp_max.textColor = grndLevel.textColor
            temp_max.font = grndLevel.font
        }
    }
    @IBOutlet weak var temp_min: UILabel!
        {
        didSet
        {
            temp_min.textColor = grndLevel.textColor
            temp_min.font = grndLevel.font
        }
    }
    
    
    @IBOutlet weak var sunrise: UILabel!
        {
        didSet{
            sunrise.textColor = grndLevel.textColor
            sunrise.font = grndLevel.font
        }
    }
    
    @IBOutlet weak var sunset: UILabel!
        {
        didSet{
            sunset.textColor = grndLevel.textColor
            sunset.font = grndLevel.font
        }
    }

    @IBOutlet weak var wind: UILabel!
        {
        didSet{
            wind.textColor = grndLevel.textColor
            wind.font = grndLevel.font
        }
    }
    
    func animationView(annimationView:UIView!)
    {
        let vie = annimationView
        let annimation = CAKeyframeAnimation(keyPath: "rotation")
        
    }
    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var ZeroDay: UIView!
        {
        didSet{
            
            var item: MenuItem? =  (MenuItem.shareItems as NSArray)[0] as? MenuItem
             self.setDetail(ZeroDay, title: item!.title, temp:"20C",icon: "01d")
        }
    }
    @IBOutlet weak var OneDay: UIView!
        {
        didSet{
        
            var item: MenuItem? =  (MenuItem.shareItems as NSArray)[1] as? MenuItem
            self.setDetail(OneDay, title: item!.title, temp:"20C",icon: "01d")
        }
    }
   
    @IBOutlet weak var TwoDay: UIView!
        {
        didSet{
            var item: MenuItem? =  (MenuItem.shareItems as NSArray)[2] as? MenuItem
            self.setDetail(TwoDay, title: item!.title, temp:"20C",icon: "01d")
        }
    }
    
    @IBOutlet weak var ThreeDay: UIView!
        {
        didSet{
            var item: MenuItem? =  (MenuItem.shareItems as NSArray)[3] as? MenuItem
            self.setDetail(ThreeDay, title: item!.title, temp:"20C",icon: "01d")
        }
    }
   
    @IBOutlet weak var FourDay: UIView!
        {
        didSet{
            var item: MenuItem? =  (MenuItem.shareItems as NSArray)[4] as? MenuItem
            self.setDetail(FourDay, title: item!.title, temp:"20C",icon: "01d")
        }
    }
    
    @IBOutlet weak var FiveDay: UIView!
        {
        didSet{
            var item: MenuItem? =  (MenuItem.shareItems as NSArray)[5] as? MenuItem
            self.setDetail(FiveDay, title: item!.title, temp:"20C",icon: "01d")
        }
    }
    @IBOutlet weak var SixDay: UIView!
        {
        didSet{
            var item: MenuItem? =  (MenuItem.shareItems as NSArray)[6] as? MenuItem
            self.setDetail(SixDay, title: item!.title, temp:"20C",icon: "01d")
        }
    }
    
    func setDetail(view: UIView, title: String, temp: String, icon: String)
    {
        
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height/3))
        label.text = title
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(12)
        label.tag = 1
        view.addSubview(label)
        
       var imageView = UIImageView(image: UIImage(named: icon))
        imageView.frame = CGRect(x: 0, y: CGRectGetMaxY(label.frame), width: view.bounds.height/3, height: view.bounds.height/3)
        imageView.center.x = view.bounds.width/2.0
        imageView.tag = 2
        view.addSubview(imageView)
        
       var label2 = UILabel(frame: CGRect(x: 0, y: CGRectGetMaxY(imageView.frame), width: view.bounds.width, height: view.bounds.height/3))
        label2.text = temp
        label2.tag = 3
        label2.textAlignment = NSTextAlignment.Center
        label2.textColor = UIColor.whiteColor()
        label2.font = UIFont.systemFontOfSize(12)
        view.addSubview(label2)
        
    }

    
    
}
























