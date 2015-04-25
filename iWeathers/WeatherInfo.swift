//
//  WeatherInfo.swift
//  iWeathers
//
//  Created by pangfuli on 15/4/20.
//  Copyright (c) 2015年 pfl. All rights reserved.
//

import UIKit

struct weatherInfo {
    var icon: String?
    var humidity: String?
    var temp: String?
    var temp_max: String?
    var temp_min: String?
    var wind: String?
    var sunrise: String?
    var sunset: String?
    var grdLevel: String?
    var seaLevel: String?
    var pressure: String?
}



class WeatherInfo{
    var weather: weatherInfo?
}
