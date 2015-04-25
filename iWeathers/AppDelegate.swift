//
//  AppDelegate.swift
//  OfficeBuddy
//
//  Created by pangfuli on 15/4/6.
//  Copyright (c) 2015年 pangfuli. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        application.statusBarStyle = UIStatusBarStyle.LightContent
       let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
        let centerNaV = storyBoard.instantiateViewControllerWithIdentifier("CenterNaV") as! UINavigationController
        let centerVC = centerNaV.viewControllers?.first as! CenterViewController
        let sliderMenu = storyBoard.instantiateViewControllerWithIdentifier("SliderMenu") as! SliderMenuViewController
        centerNaV
        sliderMenu.centerVC = centerVC
        
        let containerVC = ContainerViewController(sliderVC: sliderMenu, centerVC: centerNaV)
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = containerVC
        window?.backgroundColor = UIColor.whiteColor()
        window?.makeKeyAndVisible()
        
        
        
        
        
        return true
    }


    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        if url.scheme == "iWeathers" {
           
            return true
        }
        
        return false
    }
    
}

