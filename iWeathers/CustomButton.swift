//
//  CustomButton.swift
//  OfficeBuddy
//
//  Created by pangfuli on 15/4/7.
//  Copyright (c) 2015年 pangfuli. All rights reserved.
//

import UIKit

class CustomButton: UIView {
    
    var tapHandler: (() -> ())?
    
    var imageView: UIImageView!
    
    override func didMoveToSuperview() {
        
        self.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        imageView = UIImageView(image: UIImage(named: "menu"))
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "didTap"))
        addSubview(imageView)
    }
    
    func didTap()
    {
        tapHandler?()
    }
    
}
