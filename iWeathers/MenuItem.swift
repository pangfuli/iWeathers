//
//  MenuItem.swift
//  OfficeBuddy
//
//  Created by pangfuli on 15/4/6.
//  Copyright (c) 2015年 pangfuli. All rights reserved.
//

import UIKit
import Foundation

let menuItemColor = [
    
    UIColor(red: 233/255, green: 198/255, blue:55/255, alpha: 1.0),
    UIColor(red: 213/255, green: 98/255, blue:65/255, alpha: 1.0),
    UIColor(red: 163/255, green: 58/255, blue:75/255, alpha: 1.0),
    UIColor(red: 23/255, green: 118/255, blue:95/255, alpha: 1.0),
    UIColor(red: 73/255, green: 128/255, blue:125/255, alpha: 1.0),
    UIColor(red: 67/255, green: 188/255, blue:52/255, alpha: 1.0),
    UIColor(red: 203/255, green: 138/255, blue:145/255, alpha: 1.0),
    UIColor(red: 123/255, green: 168/255, blue:167/255, alpha: 1.0),
    UIColor(red: 145/255, green: 34/255, blue: 167/255, alpha: 1.0)
]

let weekDay = ["周日","周一","周二","周三","周四","周五","周六"]
let tems = ["20C","20C","20C","20C","20C","20C","20C"];
let iocns = ["01","01","01","01","01","01","01"];

class MenuItem {
    
    let title: String
    let color: UIColor
    let symbol: String
    var temp: String?
    var icom: String?
    
    init(symbol: String,color: UIColor, title: String)
    {
        self.title = title
        self.color = color
        self.symbol = symbol
    }
    
    class var shareItems:[MenuItem] {
    
        struct Static {
           
           static let items = MenuItem.shareMenuItems()
        }
        
        return Static.items
    }
    
  class func shareMenuItems() -> [MenuItem]
    {
        var menuItems = [MenuItem]()
        menuItems.append(MenuItem(symbol: "☀️", color: menuItemColor[0], title: self.formatterDate(0)))
        menuItems.append(MenuItem(symbol: "✉️", color: menuItemColor[1], title: self.formatterDate(1)))
        menuItems.append(MenuItem(symbol: "♻️", color: menuItemColor[2], title: self.formatterDate(2)))
        menuItems.append(MenuItem(symbol: "🐴", color: menuItemColor[3], title: self.formatterDate(3)))
        menuItems.append(MenuItem(symbol: "🐂", color: menuItemColor[4], title: self.formatterDate(4)))
        menuItems.append(MenuItem(symbol: "🐑", color: menuItemColor[5], title: self.formatterDate(5)))
        menuItems.append(MenuItem(symbol: "🐔", color: menuItemColor[6], title: self.formatterDate(6)))
//        menuItems.append(MenuItem(symbol: "🐶", color: menuItemColor[7], title: self.formatterDate(0)))
//        menuItems.append(MenuItem(symbol: "🐷", color: menuItemColor[8], title: self.formatterDate(0)))
        return menuItems
    }
   
   class func formatterDate(indexDate:Int)->String!
    {
        let date = NSDate(timeInterval: NSTimeInterval(indexDate * 60 * 60 * 24), sinceDate: NSDate())
        let calender = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let unitFlags = NSCalendarUnit.CalendarUnitWeekday
        let components = calender?.components(unitFlags, fromDate: date)
        let index = components?.weekday
        return weekDay[index! - 1] as String
    }
    
}














