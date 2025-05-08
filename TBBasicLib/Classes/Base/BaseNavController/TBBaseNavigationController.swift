//
//  TBBaseNavigationController.swift
//  TBBasicLib
//
//  Created by 陶博 on 2025/5/8.
//

import Foundation
import UIKit

open class TBBaseNavigationController: UINavigationController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            // iOS 13 及以上使用 UINavigationBarAppearance 配置导航栏样式
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground() // 设置为透明背景
            appearance.titleTextAttributes = [
                .foregroundColor: navTitleTextColor,
                .font: navTitleTextFont
            ]
            
            self.navigationBar.standardAppearance = appearance
            self.navigationBar.scrollEdgeAppearance = appearance
        } else {
            // iOS 13 以下使用旧方法手动设置导航栏样式
            self.navigationBar.barTintColor = UIColor.clear
            self.navigationBar.titleTextAttributes = [
                .foregroundColor: navTitleTextColor,
                .font: navTitleTextFont
            ]
            self.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationBar.shadowImage = UIImage()
            self.navigationBar.isTranslucent = true
        }
    }
    
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count == 1 {
            viewController.hidesBottomBarWhenPushed = true
        } else {
            viewController.hidesBottomBarWhenPushed = false
        }
        super.pushViewController(viewController, animated: animated)
    }

}


extension TBBaseNavigationController: TBNavable {
    open var navTitleTextFont: UIFont {
        .systemFont(ofSize: 17)
    }
    
    
    open var navTitleTextColor: UIColor {
        .black
    }
}
