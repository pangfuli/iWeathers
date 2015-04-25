//
//  SliderMenuViewController.swift
//  OfficeBuddy
//
//  Created by pangfuli on 15/4/6.
//  Copyright (c) 2015年 pangfuli. All rights reserved.
//

import UIKit

class SliderMenuViewController: UITableViewController {

    @IBOutlet weak var addBtn: UIButton!
    var footerView: UIView?
    @IBOutlet weak var ImageViews: UIImageView!
    
//    var cities: NSMutableSet? = NSMutableSet()
    var cities: NSMutableArray? = NSMutableArray()
    var towns: NSMutableArray = NSMutableArray()
    var city: String?
    var centerVC: CenterViewController!
    var provincesAndCities: NSMutableArray? = NSMutableArray()
    var stateArr: NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "default_user_cover_other")!)
        
    
    }

    // MARK: - Table view data source

    override func viewWillAppear(animated: Bool) {

    }
    
    override func viewDidAppear(animated: Bool) {
        
        tableView.tableHeaderView = configCustomView("历史查询")
    
        tableView.tableFooterView = configCustomView("选择城市")
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return provincesAndCities!.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        let state: NSMutableDictionary = stateArr[section] as! NSMutableDictionary
        if state.objectForKey("state")!.boolValue == false
        {
            return  0
        }
        else
        {
            return  ( provincesAndCities![section] as! NSArray ).count
        }

        
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MainCell", forIndexPath: indexPath) as! UITableViewCell
        cell.backgroundColor = UIColor(patternImage: UIImage(named: "default_user_cover_other")!)
       
        if provincesAndCities!.count != 0
        {
             let cityArr = provincesAndCities![indexPath.section] as! NSArray
            let city = cityArr[indexPath.row] as! NSString
            cell.textLabel?.textColor = UIColor.whiteColor()
            cell.textLabel?.font = UIFont.systemFontOfSize(12)
            cell.textLabel?.textAlignment = .Center
            cell.textLabel?.text = city as String
            
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
       var city = cities![section] as? NSString
        if city?.length > 5
        {
            if city!.hasSuffix("地区")
            {
                city = city?.substringToIndex(city!.length-2)
            }
            else
            {
                city = city?.substringToIndex(2)
            }
        }
        if city?.length == 5
        {
            if city!.hasSuffix("地区")
            {
                city = city?.substringToIndex(city!.length-2)
            }
            else
            {
                city = city?.substringToIndex(4)
            }
        }
        return configCustomView(city as! String, index: section)
    }
    
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 20.0
    }
    


    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        

        (self.parentViewController! as! ContainerViewController).toggleSliderMenu()
        var pc = cities![indexPath.section] as! String
        let city = provincesAndCities![indexPath.section][indexPath.row] as! String
        self.centerVC.geocodeLocation(pc + city)
    }
    
    
    
    func configCustomView(text: String, index: Int = 0)->UIView?
    {
        let views = UIView(frame: CGRect(x: 0, y: 10, width: self.view.bounds.width, height: 44))
        let label = UILabel(frame: CGRect(x: 5, y: 0, width: self.view.bounds.width*2/3, height: 24))
        label.text = text
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.boldSystemFontOfSize(13)
        views.addSubview(label)
        
        let imageView = UIImageView()
        var image: UIImage?
        
        if text == "选择城市"
        {
            
            views.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "searchCities"))
            image = UIImage(named: "add")
            
        }
        else if text == "历史查询"
        {
    
            image = UIImage(named: "list")
            
        }
        else
        {
            views.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 24)
            let state: NSMutableDictionary = stateArr[index] as! NSMutableDictionary
            if state.objectForKey("state")!.boolValue == true
            {
                
               image = UIImage(named: "up")
            }
            else
            {
                
                image = UIImage(named: "down")
            }
            
            label.textAlignment = NSTextAlignment.Center
            label.userInteractionEnabled = true
            label.tag = index
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "openCell:"))
            
        }
        
        imageView.image = image!
        imageView.frame = CGRect(x: self.view.bounds.width*2/3, y: 0, width: image!.size.width/2, height: image!.size.height/2)
        imageView.center.y = views.center.y
        label.center.y = views.center.y
        views.addSubview(imageView)
        
        return views
    }
    
    
    func openCell(tap: UITapGestureRecognizer)
    {
        
        let state: NSMutableDictionary = stateArr[tap.view!.tag] as! NSMutableDictionary
        if state.objectForKey("state")!.boolValue == true
        {
            state.setObject(false, forKey: "state")
           
        }
        else
        {
            state.setObject(true, forKey: "state")
            
        }
        tableView.reloadData()
    }

  func searchCities()
    {
        let search = SearchTableViewController()
   
        weak var weakSelf = self
        search.SearchBarResultesClosure = { (city:String,towms: NSArray)->Void in
            
            
            if !weakSelf!.isContainCity(city)
            {
                weakSelf!.cities!.addObject(city)
                weakSelf!.provincesAndCities?.addObject(towms)
                var stateDic: NSMutableDictionary = NSMutableDictionary(dictionary: ["state" : false])
                weakSelf!.stateArr.addObject(stateDic)
                weakSelf!.tableView.reloadData()
                
            }

                        
        }
    
        let nav = UINavigationController(rootViewController: search)
        
        self.presentViewController(nav, animated: true, completion: nil)
        
    }

    
    func isContainCity(city: String)->Bool
    {
        let cities = self.cities?.copy() as! NSArray
        if cities.containsObject(city)
        {
            return true
        }
        
        return false
    }
    

}




