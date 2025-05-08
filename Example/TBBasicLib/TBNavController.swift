//
//  TBNavController.swift
//  TBBasicLib_Example
//
//  Created by 陶博 on 2025/5/8.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit
import TBBasicLib

class TBNavController: TBBaseNavigationController {
    
    override var navTitleTextColor: UIColor {
        .red
    }
    
    override var navTitleTextFont: UIFont {
        .systemFont(ofSize: 20)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
