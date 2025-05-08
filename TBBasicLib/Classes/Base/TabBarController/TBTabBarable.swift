//
//  TBTabBarable.swift
//  TBBasicLib
//
//  Created by 陶博 on 2025/5/7.
//

import Foundation
import UIKit


@objc public protocol TBTabBarable {
    
    /// 背景颜色
    var tabBarBackgroundColor: UIColor { get }
    
    /// 未选中的文字font
    var textNormalFont: UIFont { get }
    
    /// 选中的文字font
    var textSelectedFont: UIFont { get }
    
    /// 未选中的文字颜色
    var textNormalColor: UIColor { get }
    
    /// 选中的文字颜色
    var textSelectedColor: UIColor { get }
    
    /// tabbar的VC
    var tabBarViewControllers: [TBTabBarVCModel] { get }
    
    
}




