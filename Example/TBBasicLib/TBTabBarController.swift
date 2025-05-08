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
    
    
    override var tabBarViewControllers: [TBTabBarVCModel] {
        (0...3).map {
            TBTabBarVCModel(vc: ViewController(),
                            title: "\($0)12",
                            normalImage: UIImage(systemName: "square.and.arrow.up") ?? UIImage(),
                            selectedImage: UIImage(systemName: "square.and.arrow.up") ?? UIImage(),
                            navType: TBNavController.self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
}
