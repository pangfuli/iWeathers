//
//  CenterViewController.swift
//  OfficeBuddy
//
//  Created by pangfuli on 15/4/6.
//  Copyright (c) 2015年 pangfuli. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import iAd


let kRefreshViewHeight: CGFloat = 110.0
let kTimeInterval: NSTimeInterval = 0.5 * 1.2

func delay(#seconds: Double, completion:()->()) {
    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
    
    dispatch_after(popTime, dispatch_get_main_queue()) {
        completion()
    }
}

class CenterViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate,UIScrollViewDelegate,RefreshViewDelegate,ADBannerViewDelegate {
    
    var adView: ADBannerView?
    
    let radius: CGFloat = 50.0
    var startTime: String?
    var endTime: String?
    var finalAngle: CGFloat?
    
    var weatherInfo: NSMutableDictionary? = NSMutableDictionary()
    var menuButton:CustomButton?
    var mapViewManager: CLLocationManager?
    var locationCoordinate: CLLocationCoordinate2D?
    var annotation: AnnotationView?
    var isFirst = false
    var isDrag = false
    var addressDictionary:[NSObject : AnyObject]?
    var city: NSString?
    var temperature: NSString?
    var coverView: UIView?
    var refreshView: RefreshView!
    {
        didSet
        {
            coverView?.backgroundColor = UIColor.blackColor()
            coverView?.alpha = 0.7
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
        {
        didSet{
            mapView.mapType = MKMapType.Standard
            mapView.showsUserLocation = true
            mapView.userInteractionEnabled = true
            mapView.delegate = self
        }
    }
    
    @IBOutlet var centerScrollView: CenterScrollView!
        {
        didSet{
            centerScrollView.delegate = self
            centerScrollView.contentSize = CGSize(width:0, height:UIScreen.mainScreen().bounds.height+1)
            centerScrollView.showsVerticalScrollIndicator = false
        }
    }
    
    var itemMenu: MenuItem!{
        
        didSet{
//            self.title = itemMenu.title
//            self.view.backgroundColor = itemMenu.color
//            symbol.text = itemMenu.symbol
            self.view.backgroundColor = UIColor(red: 0.0, green: 154.0/255.0, blue: 222.0/255.0, alpha: 1.0)
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.navigationController!.navigationBar.barTintColor = UIColor(red: 0.0, green: 154.0/255.0, blue: 222.0/255.0, alpha: 1.0)
        self.automaticallyAdjustsScrollViewInsets = false
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillResignActives", name: UIApplicationWillResignActiveNotification, object: nil)
        
        let refreshRect = CGRect(x: 0.0, y: -48, width: view.frame.size.width, height: kRefreshViewHeight)
        refreshView = RefreshView(frame: refreshRect, scrollView:self.centerScrollView)
        refreshView.delegate = self
        view.addSubview(refreshView)
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        mapView.center = CGPoint(x: self.view.center.x, y: mapView.center.y)
        
        itemMenu = MenuItem.shareItems.first!
        menuButton = CustomButton()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.menuButton!)
        menuButton?.tapHandler = {
                   self.tapHandle()
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "share")
        
        
        configMapViewManager()
        
        let animationView = AnimationView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        animationView.center = CGPoint(x: self.view.center.x, y: CGRectGetMaxY(centerScrollView.temp.frame)+50)
        view.addSubview(animationView)
        animationView.tag = 100
        
    
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        adView = ADBannerView(frame: CGRect(x: 0, y: UIScreen.mainScreen().bounds.height - 48, width: UIScreen.mainScreen().bounds.width, height: 44))
        adView!.delegate = self
        adView?.backgroundColor = UIColor.clearColor()
        view.addSubview(adView!)
    }
   
    
    
   @objc private func applicationWillResignActives()
    {
        saveDefaults()
    }
    
    private func saveDefaults()
    {
        let userDefault = NSUserDefaults(suiteName: "group.iWeatherShareDefaults")
        userDefault?.setObject(weatherInfo, forKey: "com.pfl.iWeathers.weatherInfo")
        userDefault?.synchronize()
    }
    
    private func clearDefaulfs()
    {
        let userDefault = NSUserDefaults(suiteName: "group.iWeatherShareDefaults")
        userDefault?.removeObjectForKey("com.pfl.iWeathers.weatherInfo")
        userDefault?.synchronize()
    }
    
    // MARK: ADBannerViewDelegate
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        
        banner.hidden = false
        println("loaded ")
    }
    
    func bannerViewActionDidFinish(banner: ADBannerView!) {
        println("finish")
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
       
        banner.hidden = true
        println("error")
    }
    
    // MARK: Refresh control methods
    func refreshViewDidRefresh(refreshView: RefreshView) {
        
        delay(seconds: 3) {
//            refreshView.endRefreshing()
            self.geocodeLocation(self.city!)
           
        }
    }
    
    
    // MARK: Scroll view methods
    func scrollViewDidScroll(scrollView: UIScrollView) {
        refreshView.scrollViewDidScroll(scrollView)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
       
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if !refreshView.isRefreshing && refreshView.progress >= 1.0
        {
            isDrag = true
        }
        refreshView.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
        
    
    }
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        initailFrame()
        
    }
    
    func share()
    {
        var items:[NSObject]?
        
        if let tempCity = self.city
        {
            items = ["\(city!)现在的温度\(temperature!)"]
        }
        else
        {
            items = ["暂无城市信息!"]
        }
        
        if let tempTemperature = self.temperature
        {
            items = ["\(city!)现在的温度\(temperature!)"]
        }
        else
        {
            items = ["暂无温度信息"]
        }
        
        
        let social = UIActivityViewController(activityItems: items!, applicationActivities: nil)
        self.presentViewController(social, animated: true, completion: nil)
    }
    
    
    func getWeekWeatherData(locationCoordinate: CLLocationCoordinate2D!)
    {
        self.configMapView(locationCoordinate)
        
        
        let url = "http://api.openweathermap.org/data/2.5/forecast/daily"
        
        let parameter = ["lat": locationCoordinate.latitude,"lon": locationCoordinate.longitude,"cnt": 7,"mode":"json"]
        
        Alamofire.request(.GET, url, parameters: parameter as? [String : AnyObject]).responseJSON { (_, _, json, error) -> Void in
            
            if error == nil && json != nil
            {
//                println(json)
                
                if let response: AnyObject = json
                {
                    
                    if response.isKindOfClass(NSDictionary.self)
                    {
                        let list = (response as! NSDictionary)["list"] as! NSArray
                        var i = 0
                        for dict in list as [AnyObject]
                        {
                            
                            let tem =  ((dict as! NSDictionary)["temp"] as! NSDictionary)["morn"] as! Double - 273.15
                            let icon =  ((dict as! NSDictionary)["weather"] as! NSArray)[0]["icon"] as! String
                            
                            switch i
                            {
                            case 0:
                                let imageView =  self.centerScrollView.ZeroDay.viewWithTag(2) as! UIImageView
                                let lab2 =  self.centerScrollView.ZeroDay.viewWithTag(3) as! UILabel
                                imageView.image = UIImage(named: icon)
                                lab2.text = NSString(format: "%0.1f°C", tem) as String
                                
                            case 1:
                                let imageView =  self.centerScrollView.OneDay.viewWithTag(2) as! UIImageView
                                let lab2 =  self.centerScrollView.OneDay.viewWithTag(3) as! UILabel
                                imageView.image = UIImage(named: icon)
                                lab2.text = NSString(format: "%0.1f°C", tem) as String
                            case 2:
                                let imageView =  self.centerScrollView.TwoDay.viewWithTag(2) as! UIImageView
                                let lab2 =  self.centerScrollView.TwoDay.viewWithTag(3) as! UILabel
                                imageView.image = UIImage(named: icon)
                                lab2.text = NSString(format: "%0.1f°C", tem) as String
                            case 3:
                                let imageView =  self.centerScrollView.ThreeDay.viewWithTag(2) as! UIImageView
                                let lab2 =  self.centerScrollView.ThreeDay.viewWithTag(3) as! UILabel
                                imageView.image = UIImage(named: icon)
                                lab2.text = NSString(format: "%0.1f°C", tem) as String
                            case 4:
                                let imageView =  self.centerScrollView.FourDay.viewWithTag(2) as! UIImageView
                                let lab2 =  self.centerScrollView.FourDay.viewWithTag(3) as! UILabel
                                imageView.image = UIImage(named: icon)
                                lab2.text = NSString(format: "%0.1f°C", tem) as String
                            case 5:
                                let imageView =  self.centerScrollView.FiveDay.viewWithTag(2) as! UIImageView
                                let lab2 =  self.centerScrollView.FiveDay.viewWithTag(3) as! UILabel
                                imageView.image = UIImage(named: icon)
                                lab2.text = NSString(format: "%0.1f°C", tem) as String
                            case 6:
                                let imageView =  self.centerScrollView.SixDay.viewWithTag(2) as! UIImageView
                                let lab2 =  self.centerScrollView.SixDay.viewWithTag(3) as! UILabel
                                imageView.image = UIImage(named: icon)
                                lab2.text = NSString(format: "%0.1f°C", tem) as String
                                
                            default:
                                break
                            }
                            
                            
                            i++
                        }
                        
                        
                        
                    }
                    
                }
                

            }
            else
            {
                
            }
        }
        
    }


    func getWeatherData(locationCoordinate: CLLocationCoordinate2D!)
    {
        
        self.configMapView(locationCoordinate)
        
       
        let url = "http://api.openweathermap.org/data/2.5/weather"
        let parameter = ["lat": locationCoordinate.latitude,"lon": locationCoordinate.longitude,"cnt": 1,"mode":"json"]
        Alamofire.request(.GET, url, parameters: parameter as? [String : AnyObject]).responseJSON { (request, response, json, error) -> Void in
            
//            println(request)
//            println(response)
//            println(error)
            
            if error == nil && json != nil
            {
                
                UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: nil, animations: { () -> Void in
                    
                    
                    self.updateWeatherInfo(json as! NSDictionary)
                    
                    self.centerScrollView.weatherIcon.center.x = self.centerScrollView.weatherIcon.bounds.width*2.5
                    self.centerScrollView.temp.center.x = self.centerScrollView.weatherIcon.center.x
                    self.centerScrollView.temp_max.center.x = abs(self.centerScrollView.temp_max.center.x)
                    self.centerScrollView.temp_min.center.x = abs(self.centerScrollView.temp_min.center.x)
                    self.centerScrollView.sunrise.center.x = abs(self.centerScrollView.sunrise.center.x)
                    self.centerScrollView.sunset.center.x = abs(self.centerScrollView.sunset.center.x)
                    
                    
                    if self.isDrag
                    {
                        self.refreshView.endRefreshing()
                        self.isDrag = false
                    }
                    
                    }, completion: { _ in
                        
                        let animationView: UIView? = self.centerScrollView.viewWithTag(100)
                        animationView?.removeFromSuperview()
                        
                        UIView.animateWithDuration(kTimeInterval, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: nil, animations: { () -> Void in
                            self.centerScrollView.grndLevel.center.x = abs(self.centerScrollView.grndLevel.center.x)
                            }, completion: { _ in
                                UIView.animateWithDuration(kTimeInterval * 4/5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: nil, animations: { () -> Void in
                                    self.centerScrollView.sea_level.center.x = abs(self.centerScrollView.sea_level.center.x)
                                    }, completion: {_ in
                                        UIView.animateWithDuration(kTimeInterval * 3/5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: nil, animations: { () -> Void in
                                            self.centerScrollView.humidity.center.x = abs(self.centerScrollView.humidity.center.x)
                                            }, completion: {_ in
                                                UIView.animateWithDuration(kTimeInterval * 2/5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: nil, animations: { () -> Void in
                                                    self.centerScrollView.pressure.center.x = abs(self.centerScrollView.pressure.center.x)
                                                    }, completion: {_ in
                                                        UIView.animateWithDuration(kTimeInterval * 1/5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: nil, animations: { () -> Void in
                                                            self.centerScrollView.wind.center.x = abs(self.centerScrollView.wind.center.x)
                                                            self.centerScrollView.baseView.center.x = abs(self.centerScrollView.baseView.center.x)
                                                            }, completion: {_ in
                                                                
                                                        })
                                                        
                                                })
                                        })
                                })
                        })
                        
                        
                })

                
            }
            else
            {
                
                if self.isDrag
                {
                    self.refreshView.endRefreshing()
                    self.isDrag = false
                }
                self.centerScrollView.temp.text = "无法获取您的天气信息!"
                
                let animationView: UIView? = self.centerScrollView.viewWithTag(100)
                animationView?.removeFromSuperview()
                
            }
            
        }
        
       
        
      
    }
    
    
    func updateWeatherInfo(responesObject: NSDictionary!)
    {
        
        if let temp = responesObject["main"]?["temp"] as? Double
        {
            centerScrollView.temp.text = NSString(format: "%0.1f°C", (temp - 273.15)) as String
            self.temperature = centerScrollView.temp.text!
        }
        else
        {
            centerScrollView.temp.text = "无法获取您的天气信息!"
        }
        
        
        if let weather = responesObject["weather"]?[0]["icon"] as? String
        {
            centerScrollView.weatherIcon.image = UIImage(named: weather)
            weatherInfo?.setObject(weather, forKey: "icon")
        }
        
        if let grndLevel = responesObject["main"]?["grnd_level"] as? Double
        {
            centerScrollView.grndLevel.text = NSString(format: "grndLevel: %0.2f", (grndLevel)) as String
        }
    
        if let humidity = responesObject["main"]?["humidity"] as? Double
        {
            centerScrollView.humidity.text = NSString(format: "humidity: %0.1f%%", (humidity)) as String
        }
        if let pressure = responesObject["main"]?["pressure"] as? Double
        {
            centerScrollView.pressure.text = NSString(format: "pressure: %0.2f", (pressure)) as String
        }
        if let sea_level = responesObject["main"]?["sea_level"] as? Double
        {
            centerScrollView.sea_level.text = NSString(format: "seaLevel: %0.2f", (sea_level)) as String
        }
        if let temp_max = responesObject["main"]?["temp_max"] as? Double
        {
            centerScrollView.temp_max.text = NSString(format: "Higth: %0.1f°C", (temp_max - 273.15)) as String
        }
        if let temp_min = responesObject["main"]?["temp_min"] as? Double
        {
            centerScrollView.temp_min.text = NSString(format: "Low: %0.1f°C", (temp_min - 273.15)) as String
        }
        if let wind = responesObject["wind"]?["speed"] as? Double
        {
            centerScrollView.wind.text = NSString(format: "wind: %0.2fmps", wind) as String
        }
        
        if let sunrise = responesObject["sys"]?["sunrise"] as? NSTimeInterval
        {
            
            let date = NSDate(timeIntervalSince1970: sunrise)
            let calender = NSCalendar.currentCalendar()
            let unit = NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute
            let component = calender.components(unit, fromDate: date)
            let sun_rise = "🌝\(component.hour):\(component.minute)"
            centerScrollView.sunrise.text = sun_rise
            weatherInfo?.setObject("\(component.hour):\(component.minute)", forKey: "sunrise")
            startTime = "\(component.hour):\(component.minute)"
        }
        
        if let sunset = responesObject["sys"]?["sunset"] as? NSTimeInterval
        {
            
            let date = NSDate(timeIntervalSince1970: sunset)
            let calender = NSCalendar.currentCalendar()
            let unit = NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute
            let component = calender.components(unit, fromDate: date)
            let sun_set = "🌚\(component.hour):\(component.minute)"
            centerScrollView.sunset.text = sun_set
            weatherInfo?.setObject("\(component.hour):\(component.minute)", forKey: "sunset")
            endTime = "\(component.hour):\(component.minute)"
        }
        
        
        weatherInfo?.setObject(self.temperature as! String, forKey: "temp")
        weatherInfo?.setObject(centerScrollView.temp_max.text!, forKey: "temp_max")
        weatherInfo?.setObject(centerScrollView.temp_min.text!, forKey: "temp_min")
        weatherInfo?.setObject(centerScrollView.humidity.text!, forKey: "humidity")
        weatherInfo?.setObject(self.title!, forKey: "city")
        
    }
    
    

    func tapHandle()
    {
        (self.navigationController?.parentViewController! as! ContainerViewController).toggleSliderMenu()
    }
    
    func configMapViewManager()
    {
        centerScrollView.symbol.center.x = -centerScrollView.bounds.width/2
        mapViewManager = CLLocationManager()
        mapViewManager?.desiredAccuracy = kCLLocationAccuracyBest
        mapViewManager?.distanceFilter = kCLLocationAccuracyNearestTenMeters
        mapViewManager?.requestAlwaysAuthorization()
        mapViewManager?.startUpdatingLocation()
        mapViewManager?.delegate = self
    }

    // Mark CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
       let isaVailable =  CLLocationManager.locationServicesEnabled()
        if isaVailable == false
        {
            return
        }
        
        manager.stopUpdatingLocation()
        
        locationCoordinate = (locations.last as! CLLocation).coordinate
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: locationCoordinate!.latitude, longitude: locationCoordinate!.longitude)
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            let placeMarks = placemarks as NSArray
            if placeMarks.count > 0
            {
                let placemark = placeMarks.firstObject as! CLPlacemark
                self.addressDictionary = placemark.addressDictionary
                let city = placemark.addressDictionary["City"] as! NSString
                self.city = city
                self.title = city as String
                self.centerScrollView.symbol.text = NSString(format: "您所在位置:%@", (placemark.addressDictionary["Name"] as? String)!) as String
                
                UIView.animateWithDuration(0.6, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: nil, animations: { () -> Void in
                    self.centerScrollView.symbol.center.x = self.centerScrollView.bounds.width/2
                    }, completion: nil)
                
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                

                self.getWeatherData(self.locationCoordinate)
                self.getWeekWeatherData(self.locationCoordinate)
                
                
                self.annotation = AnnotationView(title: self.centerScrollView.symbol.text!, subTitle: "", locationCoordinate: self.locationCoordinate!)
                if self.isFirst == false
                {
                    UIView.animateWithDuration(0.2, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options: nil, animations: { () -> Void in
                        
                    self.mapView.center = CGPoint(x: self.centerScrollView.center.x, y: self.mapView.center.y)
                        
                        
                        }, completion: {
                            _ in
                         
                             self.mapView.addAnnotation(self.annotation)
                    })
                    
                    
                    self.isFirst = true
                }
                
            })
            
            
        })
        
        
        configMapView(self.locationCoordinate!)
        
    }
    
    // Mark MKMapViewDelegate
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
 
        
        if annotation.isKindOfClass(MKUserLocation.self)
        {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("cell") as? MKPinAnnotationView
        
        if (annotationView == nil)
        {
           annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "cell") as MKPinAnnotationView
        }
       
        annotationView!.image = UIImage(named: "sign")
        annotationView!.animatesDrop = true
        annotationView!.canShowCallout = true
        
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        btn.setImage(UIImage(named: "map_nav_go"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "default_user_cover_other"), forState: UIControlState.Normal)
        annotationView!.rightCalloutAccessoryView = btn
        btn.addTarget(self, action: "openNavagationMap", forControlEvents: UIControlEvents.TouchUpInside)
    
        return annotationView!
    }
    
    
    func openNavagationMap()
    {
        let place = MKPlacemark(coordinate: locationCoordinate!, addressDictionary: self.addressDictionary!)
        let item = MKMapItem(placemark: place)
        item.openInMapsWithLaunchOptions(nil)
        
    }
    
    
    func configMapView(locationCoordinate: CLLocationCoordinate2D!)
    {
        
        let span = MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)
        let region = MKCoordinateRegion(center:locationCoordinate, span: span)
        mapView.region = region
        
    }
    

    
    func geocodeLocation(address: NSString?)
    {
     
        if address == nil {return}
        
        city = address
        self.title = city as? String
        
        initailFrame()
        
        if isDrag == false
        {
            let animationView = AnimationView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            animationView.center = CGPoint(x: self.centerScrollView.center.x, y: CGRectGetMaxY(centerScrollView.temp.frame)+50)
            centerScrollView.addSubview(animationView)
            animationView.tag = 100
        }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address as? String, completionHandler: { (placemarks, error) -> Void in
            
            let placemark = (placemarks as NSArray!)!.firstObject as! CLPlacemark
        
            let coordinate: CLLocationCoordinate2D = placemark.location.coordinate
            self.locationCoordinate = coordinate
            let dictionary: NSDictionary = placemark.addressDictionary
            self.addressDictionary = dictionary as [NSObject : AnyObject]
 
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.getWeatherData(coordinate)
                self.getWeekWeatherData(coordinate)
                
                self.mapView.removeAnnotation(self.annotation)
                self.annotation = AnnotationView(title: address as! String, subTitle: "", locationCoordinate:coordinate)
                UIView.animateWithDuration(0.2, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options: nil, animations: { () -> Void in
                    
                        
                        }, completion: {
                            _ in
                        
                            self.mapView.addAnnotation(self.annotation)
                    })
        
                
            })
        })
        
        
    }
    
    
   func initailFrame()
   {
        centerScrollView.temp.center.x = -centerScrollView.bounds.width/2
        centerScrollView.weatherIcon.center.x = centerScrollView.bounds.height*2
        centerScrollView.grndLevel.center.x = -abs(centerScrollView.grndLevel.center.x)
        centerScrollView.sea_level.center.x = -abs(centerScrollView.sea_level.center.x)
        centerScrollView.pressure.center.x = -abs(centerScrollView.pressure.center.x)
        centerScrollView.humidity.center.x = -abs(centerScrollView.humidity.center.x)
        centerScrollView.temp_max.center.x = -abs(centerScrollView.temp_max.center.x)
        centerScrollView.temp_min.center.x = -abs(centerScrollView.temp_min.center.x)
        centerScrollView.wind.center.x = -abs(centerScrollView.wind.center.x)
        centerScrollView.sunset.center.x = -abs(centerScrollView.sunset.center.x)
        centerScrollView.sunrise.center.x = -abs(centerScrollView.sunrise.center.x)
        centerScrollView.baseView.center.x = -abs(centerScrollView.baseView.center.x)
   
    }

    
}














