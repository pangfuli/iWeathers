//
//  SearchTableViewController.swift
//  OfficeBuddy
//
//  Created by pfl on 15/4/9.
//  Copyright (c) 2015年 pangfuli. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController,UISearchBarDelegate {

   
    var SearchBarResultesClosure: ((city:String, towms: NSArray)->())?
    var searchBar: UISearchBar?
    var searchResults: NSMutableArray?
    var cities: NSMutableArray? = NSMutableArray()
    var provinces: NSArray = (AreaSingleton.ShareAreaSingleton.areaInfo as NSArray)[0] as! NSArray
    var allCities: NSArray = (AreaSingleton.ShareAreaSingleton.areaInfo as NSArray)[1] as! NSArray
    var allTowns: NSDictionary = (AreaSingleton.ShareAreaSingleton.areaInfo as NSArray)[2] as! NSDictionary

    var isSearch: Bool = false
    var areaSingleton: AreaSingleton? = AreaSingleton.ShareAreaSingleton.0
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar = UISearchBar(frame: CGRect(x: 30, y: 0, width: self.view.bounds.width - 60, height: 30))
        searchBar?.delegate = self
        searchBar?.placeholder = "搜索"
        searchBar?.layer.cornerRadius = 5.0
        searchBar?.layer.masksToBounds = true
        searchResults = NSMutableArray()
        
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Rewind, target: self, action: "cancel:")
        self.navigationItem.titleView = searchBar
        
        
//        paresDataForCities()
        
    }
    
    func cancel(selectedCity:String?)
    {
        if selectedCity == nil || selectedCity == "" {self.dismissViewControllerAnimated(true, completion: nil);return}
       
        ((self.navigationController?.presentingViewController as! ContainerViewController).childViewControllers.last! as! SliderMenuViewController).centerVC.geocodeLocation(selectedCity!)
        (self.navigationController?.presentingViewController as! ContainerViewController).toggleSliderMenu()
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
 
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       
        if isSearch
        {
            return 1
        }
        else
        {
            return provinces.count

        }
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        if isSearch
        {
            return self.cities!.count
        }
    
        self.cities!.removeAllObjects()
        let cities = areaSingleton?.getCitiesFromProvince(provinces, section:section)
        self.cities?.addObjectsFromArray(cities as! [AnyObject])
        return self.cities!.count
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier") as! UITableViewCell
        if isSearch
        {
            cell.textLabel?.text = self.cities![indexPath.row] as? String
        }
        else
        {
            let city = ((((provinces[indexPath.section] as! NSDictionary)["citylist"] as! NSArray)[indexPath.row]) as! NSDictionary)["cityName"] as? String
            cell.textLabel?.text = city

        }
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
        var selectedCity:String?
        
        if isSearch
        {
            selectedCity = self.cities![indexPath.row] as? String
    
        }
        else
        {

            selectedCity = areaSingleton?.getOneCity(provinces,indexPath: indexPath)
            println(allTowns[selectedCity!])
        }
        
        if (self.SearchBarResultesClosure != nil)
        {
//            self.SearchBarResultesClosure?(city: selectedCity!,towms: ((areaSingleton!.towns![selectedCity!] as? NSArray) != nil ? (areaSingleton!.towns![selectedCity!] as! NSArray) : []))
            
            self.SearchBarResultesClosure?(city: selectedCity!,towms: ((allTowns[selectedCity!] as? NSArray) ?? []))
        }
        
      
   
        self.cancel(selectedCity)
        
    }
    
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isSearch
        {
            return 0
        }
        return 30
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isSearch
        {
            return ""
        }
        
        let obj = provinces[section] as! NSDictionary
        let provinceN = obj["provinceName"]! as! NSString
        return provinceN as String
    }

    
    
    

   // MARK: - SearchBarDelegate
    
  
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0
        {
            isSearch = false
            tableView.reloadData()
            return
        }
        
        
        var temArr = NSMutableArray()
       allCities.enumerateObjectsUsingBlock({ (obj, idx, stop) -> Void in
        
        let city = obj as! NSString
        let text = NSString(string: searchText)
        
        let range = city.rangeOfString(text as String) as NSRange
        
        let loc = range.location
        
        if loc != NSNotFound
        {
            temArr .addObject(city)
        }
       })
        
        if temArr.count != 0
        {
            isSearch = true
            cities?.removeAllObjects()
            cities?.addObjectsFromArray(temArr as [AnyObject])
            tableView.reloadData()
        }
        
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        isSearch = false
        tableView.reloadData()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        self.cancel(nil)
    }
    
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
        searchBar.setShowsCancelButton(true, animated: true)
        
    }
   
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
    
}










