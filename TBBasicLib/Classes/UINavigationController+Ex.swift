//
//  UINavigationController.swift
//  Togethr
//
//  Created by 陶博 chen on 2024/8/16.
//

import Foundation
import UIKit

enum NavigationBarStyle {
    /// navbar APP主题
    case theme
    /// navbar 透明
    case clear
    /// navbar 白色的
    case white
    // 自定义颜色
    case color(_ color: UIColor)
}

extension UINavigationController {

func navBarStyle(_ style:NavigationBarStyle) {
        switch style {
        case .theme:
            navigationBar.barStyle = .black
            let attrDic = [NSAttributedString.Key.foregroundColor:UIColor.black,
                                                 NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18.0)]
            if #available(iOS 13.0, *) {
                let barApp = UINavigationBarAppearance()
                barApp.backgroundColor = .white
                // 基于backgroundColor或backgroundImage的磨砂效果
                barApp.backgroundEffect = nil
                // 阴影颜色（底部分割线），当shadowImage为nil时，直接使用此颜色为阴影色。如果此属性为nil或clearColor（需要显式设置），则不显示阴影。
                // barApp.shadowColor = nil;
                // 标题文字颜色
                barApp.titleTextAttributes = attrDic
                navigationBar.scrollEdgeAppearance = barApp
                navigationBar.standardAppearance = barApp
            } else {
                navigationBar.titleTextAttributes = attrDic
                
                let navBgImg = UIImage(named: "nav_bg")!.withRenderingMode(.alwaysOriginal)
                
                navigationBar.shadowImage = UIImage()
                navigationBar.setBackgroundImage(navBgImg, for: .default)
            }
            // 透明设置
            navigationBar.isTranslucent = false
            // navigationItem控件的颜色
            navigationBar.tintColor = .white
            
        case .clear:
            navigationBar.barStyle = .black
            let attrDic = [NSAttributedString.Key.foregroundColor: UIColor.white,
                           NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
            
            if #available(iOS 13.0, *) {
                let barApp = UINavigationBarAppearance()
                barApp.backgroundColor = .clear
                // 基于backgroundColor或backgroundImage的磨砂效果
                barApp.backgroundEffect = nil
                // 阴影颜色（底部分割线），当shadowImage为nil时，直接使用此颜色为阴影色。如果此属性为nil或clearColor（需要显式设置），则不显示阴影。
                // barApp.shadowColor = nil;
                // 标题文字颜色
                barApp.titleTextAttributes = attrDic
                navigationBar.scrollEdgeAppearance = nil
                navigationBar.standardAppearance = barApp
            } else {
//                navigationBar.titleTextAttributes = attrDic
//                navigationBar.shadowImage = UIImage()
//                let navBgImg = UIImage.imgColor(UIColor.clear, CGSize(width: SCREEN_WIDTH, height: kNav_Height)).withRenderingMode(.alwaysOriginal)
//                
//                navigationBar.setBackgroundImage(navBgImg, for: .default)
            }
            // 透明设置
            navigationBar.isTranslucent = true
            // navigationItem控件的颜色
            // navigationBar.tintColor = .white
            
        case .white:
            
            navigationBar.barStyle = .default
            let attrDic = [NSAttributedString.Key.foregroundColor: UIColor.black,
                           NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
 
            if #available(iOS 13.0, *) {
                let barApp = UINavigationBarAppearance()
                barApp.backgroundColor = .white
                // 基于backgroundColor或backgroundImage的磨砂效果
                barApp.backgroundEffect = nil
                // 阴影颜色（底部分割线），当shadowImage为nil时，直接使用此颜色为阴影色。如果此属性为nil或clearColor（需要显式设置），则不显示阴影。
                // barApp.shadowColor = nil;
                // 标题文字颜色
                barApp.titleTextAttributes = attrDic
                navigationBar.scrollEdgeAppearance = barApp
                navigationBar.standardAppearance = barApp
            } else {
//                navigationBar.titleTextAttributes = attrDic
//                
//                let navBgImg = UIImage.imgColor(UIColor.white, CGSize(width: SCREEN_WIDTH, height: kNav_Height)).withRenderingMode(.alwaysOriginal)
//                
//                navigationBar.shadowImage = UIImage()
//                navigationBar.setBackgroundImage(navBgImg, for: .default)
            }
            // 透明设置
            navigationBar.isTranslucent = false
            // navigationItem控件的颜色
            navigationBar.tintColor = .black
            
        case .color(let color):
            
            navigationBar.barStyle = .default
            let attrDic = [NSAttributedString.Key.foregroundColor: UIColor.white,
                           NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium)]
 
            if #available(iOS 13.0, *) {
                let barApp = UINavigationBarAppearance()
                barApp.backgroundColor = color
                // 基于backgroundColor或backgroundImage的磨砂效果
                barApp.backgroundEffect = nil
                // 阴影颜色（底部分割线），当shadowImage为nil时，直接使用此颜色为阴影色。如果此属性为nil或clearColor（需要显式设置），则不显示阴影。
                // barApp.shadowColor = nil;
                // 标题文字颜色
                barApp.titleTextAttributes = attrDic
                navigationBar.scrollEdgeAppearance = barApp
                navigationBar.standardAppearance = barApp
            } else {
//                navigationBar.titleTextAttributes = attrDic
//
//                let navBgImg = UIImage.imgColor(UIColor.white, CGSize(width: SCREEN_WIDTH, height: kNav_Height)).withRenderingMode(.alwaysOriginal)
//
//                navigationBar.shadowImage = UIImage()
//                navigationBar.setBackgroundImage(navBgImg, for: .default)
            }
            // 透明设置
            navigationBar.isTranslucent = true
            // navigationItem控件的颜色
//            navigationBar.tintColor = .black
            
        }
    }
}
