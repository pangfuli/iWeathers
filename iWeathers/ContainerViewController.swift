//
//  ContainerViewController.swift
//  OfficeBuddy
//
//  Created by pangfuli on 15/4/6.
//  Copyright (c) 2015年 pangfuli. All rights reserved.
//

import UIKit

let menuItemWidth: CGFloat = 100


class ContainerViewController: UIViewController {

    var centerVC: UIViewController!
    var slideMenuVC: UIViewController!
    var isOpening = false
    let animationInterval = 0.5
    var coverView: UIView?
    
    init(sliderVC: UIViewController, centerVC: UIViewController) {
        
        self.centerVC = centerVC
        self.slideMenuVC = sliderVC
        super.init(nibName: nil,bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        setNeedsStatusBarAppearanceUpdate()
//        self.navigationController!.navigationBar.tintColor = UIColor(red: 0.0, green: 154.0/255.0, blue: 222.0/255.0, alpha: 1.0)
        
        
        addChildViewController(centerVC)
        view.addSubview(centerVC.view)
        centerVC.didMoveToParentViewController(self)
        
        coverView = UIView(frame: CGRect(x: -self.view.bounds.width, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        coverView!.backgroundColor = UIColor.blackColor()
        coverView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "toggleSliderMenu"))
        view .addSubview(coverView!)


        addChildViewController(slideMenuVC)
        view.addSubview(slideMenuVC.view)
        slideMenuVC.didMoveToParentViewController(self)
        slideMenuVC.view.layer.anchorPoint.x = 1.0
        slideMenuVC.view.frame = CGRect(x: -menuItemWidth, y: 0, width: menuItemWidth, height: self.view.bounds.height)
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "handlePan:"))
        
        
    }

    func handlePan(pan:UIPanGestureRecognizer)
    {
        let locationPoint = pan.translationInView(pan.view!.superview!)
        var progress = locationPoint.x/menuItemWidth * (isOpening ? 1.0 : -1.0)
        
        progress = min(max(progress, 0.0), 1.0)
        
        if pan.state == UIGestureRecognizerState.Began
        {
            slideMenuVC.view.layer.shouldRasterize = true
            slideMenuVC.view.layer.rasterizationScale = UIScreen.mainScreen().scale
            let isOpen = floor(centerVC.view.frame.origin.x / menuItemWidth)
            isOpening = isOpen == 1 ? false : true
        }
        else if pan.state == UIGestureRecognizerState.Changed
        {
        
            self.setToPercent(isOpening ? progress: (1 - progress))
            
        }
        else
        {
            
            if (isOpening)
            {
                progress = progress > 0.5 ? 1.0 : 0.0
                
            }
            else
            {
                progress = progress > 0.5 ? 0.0 : 1.0
                
            }
           
            UIView.animateWithDuration(animationInterval, animations: { () -> Void in
                self.setToPercent(progress)
                },completion:{
                    _ in
                    
                    self.slideMenuVC.view.layer.shouldRasterize = false
                    
            })
            
        }
        
    
    }
    
    func setToPercent(percent: CGFloat)
    {
//        self.slideMenuVC.view.frame.origin.x =  (percent - 1) * menuItemWidth
        self.addCoverView(percent)
        self.centerVC.view.frame.origin.x = percent * menuItemWidth
        self.slideMenuVC.view.layer.transform = self.menuTransformForPercent(percent)
       
       let centerVC = (self.childViewControllers.first as! UINavigationController).viewControllers.first as! CenterViewController
        if let button = centerVC.menuButton
        {
             button.imageView.layer.transform = self.buttonTransformForPercent(percent)
        }
      
        
    }
    
    func toggleSliderMenu() {
        
        let isOpen = floor(centerVC.view.frame.origin.x / menuItemWidth)
        
        UIView.animateWithDuration(animationInterval, animations: { () -> Void in
            self.setToPercent(isOpen == 1 ? 0.0 : 1.0)
            
            },completion:{
                _ in
                self.slideMenuVC.view.layer.shouldRasterize = false
                
        })
        
    }
    
    func menuTransformForPercent(percent: CGFloat) -> CATransform3D
    {
        var identity = CATransform3DIdentity
        identity.m34 = -1.0/1000
        let transformTranslation = CATransform3DTranslate(identity, percent * menuItemWidth, 0, 0)
        let angle = (1 - percent) * CGFloat(-M_PI_2)
        let transformRotation = CATransform3DRotate(identity, angle, 0.0, 1.0, 0.0)
        
        return CATransform3DConcat(transformRotation, transformTranslation)
    }
    
    
    func buttonTransformForPercent(percent: CGFloat) ->CATransform3D
    {
        var identity = CATransform3DIdentity
        identity.m34 = -1.0/1000
        let angle = percent * CGFloat(-M_PI_2)
        let transformRotation = CATransform3DRotate(identity, angle, 1.0, 1.0, 0.0)
        return transformRotation
    }
    
    
    
    
    func addCoverView(percent: CGFloat)
    {
        self.coverView!.alpha = percent * 0.7

        self.coverView!.frame.origin.x = percent * menuItemWidth
        
    }
}












