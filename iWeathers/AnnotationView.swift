//
//  AnnotationView.swift
//  OfficeBuddy
//
//  Created by pfl on 15/4/10.
//  Copyright (c) 2015年 pangfuli. All rights reserved.
//

import UIKit
import MapKit

class AnnotationView: NSObject,MKAnnotation{

    var temtitle: NSString?
    var temsubtitle: NSString?
    
    var title: String?
//    {
//        return self.temtitle!
//    }
    var subtitle: String?
//    {
//            
//        return self.temsubtitle!
//            
//    }
    var temcoordinate: CLLocationCoordinate2D?
    var coordinate: CLLocationCoordinate2D
//        {
//            
//            return temcoordinate!
//        }
    
    init(title: String, subTitle: String, locationCoordinate: CLLocationCoordinate2D)
    {
        self.title = title
        self.subtitle = subTitle
        self.coordinate = locationCoordinate
        super.init()
    }
    

    
  
}
