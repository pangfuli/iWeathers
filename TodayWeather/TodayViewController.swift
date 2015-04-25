//
//  TodayViewController.swift
//  TodayWeather
//
//  Created by pfl on 15/4/20.
//  Copyright (c) 2015年 pfl. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    let x: CGFloat = 40
    let y: CGFloat = 20
    var radius: CGFloat = 0
    
    var sunrise: String?
    var sunset: String?
    @IBOutlet weak var temp: UILabel!
        {
        didSet
        {
            
        }
    }
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var temp_max: UILabel!
    @IBOutlet weak var temp_min: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var humity: UILabel!
    
    @IBOutlet weak var city: UILabel!
    
    @IBOutlet weak var baseLabel: UILabel!
    
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var startTime: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = CGSizeMake(0, 200)
        let userDefaults = NSUserDefaults(suiteName: "group.iWeatherShareDefaults")
        var weatherInfo = userDefaults?.objectForKey("com.pfl.iWeathers.weatherInfo") as? NSDictionary
        
        if let info = weatherInfo
        {
            temp.text = "NO WEATHER INFO"
        }
        
        if (weatherInfo?.objectForKey("temp") as? String != nil)
        {
             temp.text = weatherInfo?.objectForKey("temp") as? String
        }
        else
        {
             temp.text = "NO DATA"
        }
       
        if (weatherInfo?.objectForKey("temp_max") as? String != nil)
        {
            temp_max.text = weatherInfo?.objectForKey("temp_max") as? String
        }
        else
        {
            temp_max.text = "NO DATA"
        }
        
        if (weatherInfo?.objectForKey("temp_min") as? String != nil)
        {
            temp_min.text = weatherInfo?.objectForKey("temp_min") as? String
        }
        else
        {
            temp_min.text = "NO DATA"
        }
        
        if (weatherInfo?.objectForKey("humidity") as? String != nil)
        {
            humity.text = weatherInfo?.objectForKey("humidity") as? String
        }
        else
        {
            humity.text = "NO DATA"
        }
        
        if let icon = weatherInfo?.objectForKey("icon") as? String
        {
            self.icon.image = UIImage(named: icon)
        }
        else
        {
            self.icon.image = UIImage(named: "01d")
        }
        
        if let city = weatherInfo?.objectForKey("city") as? String
        {
            self.city.text = city
        }
        else
        {
            self.city.text = "NO DATA"
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "openMainController"))
        
        if let sunrise = weatherInfo?.objectForKey("sunrise") as? String
        {
            self.sunrise = sunrise
            
        }
        else
        {
            self.sunrise = "06:00"
        }
        if let sunset = weatherInfo?.objectForKey("sunset") as? String
        {
            self.sunset = sunset
            
        }
        else
        {
            self.sunset = "18:00"
        }
        
        self.startTime.text = sunrise!
        self.endTime.text = sunset!
        

        let sunView = SunView(frame: CGRect(x: 0, y: CGRectGetMaxY(baseLabel.frame)-100, width: baseLabel.bounds.width, height: 100))
        sunView.aCenter = CGPoint(x: baseLabel.bounds.width/2.0, y: baseLabel.bounds.height/2.0)
        sunView.startTime = sunrise!
        sunView.endTime = sunset!
        view.addSubview(sunView)
        
        
    }
    
     func openMainController()
    {
        extensionContext?.openURL(NSURL(string: "iWeathers://")!, completionHandler: nil)
    }
    
    
    class func formatterDate()->String?
    {
        let date = NSDate(timeInterval: NSTimeInterval(0 * 60 * 60 * 24), sinceDate: NSDate())
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        let dateStr = dateFormatter.stringFromDate(date)
        return dateStr
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
    
}
