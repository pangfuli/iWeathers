//
//  AreaSingleton.swift
//  iWeathers
//
//  Created by pfl on 15/4/23.
//  Copyright (c) 2015年 pfl. All rights reserved.
//

import Foundation




class AreaSingleton {

    class var ShareAreaSingleton: (AreaSingleton,areaInfo:NSArray) {
    
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance: AreaSingleton? = nil
            static var areaInfo: NSArray?
            
        }
        
        dispatch_once(&Static.onceToken){_ in
            
            Static.instance = AreaSingleton()
            var tuples = self.paresDataForCities()
            Static.areaInfo = [tuples.provinces,tuples.cities,tuples.towms]
        }
        return (Static.instance!,Static.areaInfo!)
    }
    
    
    struct paress {
        var cities: NSArray?
        var provinces: NSArray?
        var towns: NSDictionary?
    }
   
//    var cities: NSArray?
//    {
//        return AreaSingleton.ShareAreaSingleton.
////        return paresDataForCities().cities
//    }
//    var provinces: NSArray?
//    {
////        return paresDataForCities().provinces
//    }
    
//    var towns: NSDictionary?
//    {
////        return paresDataForCities().towms
//    }
    
    
    
    
   class func paresDataForCities()->(provinces:NSArray, cities: NSArray, towms: NSDictionary)
    {
        var towns: NSMutableDictionary = NSMutableDictionary()
        var auxProvinces: NSMutableArray = NSMutableArray()
        var auxCities: NSMutableArray = NSMutableArray()
        let path = NSBundle.mainBundle().pathForResource("citydata", ofType: "plist")
        let provinces = NSArray(contentsOfFile: path!)! as NSArray
//        weak var weakSelf = self
        provinces.enumerateObjectsUsingBlock {(obj, idx, stop) -> Void in
            
            
            
            if obj.isKindOfClass(NSDictionary.self)
            {
//               weakSelf!.towns!.removeAllObjects()
               
                let province = obj as! NSDictionary
                auxProvinces.addObject(province)
                
                let cityDic = obj as! NSDictionary
                let citylist = cityDic["citylist"] as! NSArray
                for city in citylist
                {
                    let cityName = city as! NSDictionary
                    auxCities.addObject(cityName["cityName"]!)
                   
                    var auxTown = NSMutableArray()
                    for area in cityName["arealist"] as! [NSDictionary]
                    {
                        auxTown.addObject(area["areaName"]!)
                    }
                   
                   towns.setObject(auxTown, forKey:cityName["cityName"] as! String)
                }
            }
            
            
        }
        
        return (auxProvinces, auxCities,towns)
        
    }
    
    // mark get a city
    func getOneCity(province: NSArray, indexPath: NSIndexPath)->String
    {
        let selectedCity = ((((province[indexPath.section] as! NSDictionary)["citylist"] as! NSArray)[indexPath.row]) as! NSDictionary)["cityName"] as? String
    
        return selectedCity!
    }
    
     // mark get cities
    func getCitiesFromProvince(province: NSArray,section: Int)->NSArray
    {
        let cities = (province[section] as! NSDictionary)["citylist"] as! NSArray
        return cities
    }
    
    
}







