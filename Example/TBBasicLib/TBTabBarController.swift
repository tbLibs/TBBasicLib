//
//  TBTabBarController.swift
//  TBBasicLib_Example
//
//  Created by 陶博 on 2025/5/7.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit
import TBBasicLib


class TBTabBarController: TBBaseTabBarController {
    
    static let shared = TBTabBarController()
    
    
    override var tabBarBackgroundColor: UIColor {
        .black
    }
    
    override var textNormalColor: UIColor {
        .white
    }
    
    override var textSelectedColor: UIColor {
        .red
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
}
