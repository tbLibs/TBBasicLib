//
//  UIViewController+Ex.swift
//  TV Remote Control
//
//  Created by 陶博 on 2025/3/14.
//

import Foundation
import UIKit

public extension UIViewController {
    /// 获取当前显示的VC
    ///
    /// - Returns: 当前屏幕显示的VC
    class func getCurrentViewController() -> UIViewController? {
        // 获取当先显示的window
        var currentWindow = KWindow ?? UIWindow()
        if currentWindow.windowLevel != UIWindow.Level.normal {
            let windowArr: [UIWindow]
            if #available(iOS 13.0, *) {
                windowArr = UIApplication.shared.connectedScenes
                    .compactMap { $0 as? UIWindowScene }
                    .flatMap { $0.windows }
            } else {
                windowArr = UIApplication.shared.windows
            }
            for window in windowArr where window.windowLevel == .normal {
                currentWindow = window
                break
            }
        }
        return UIViewController.getNextXController(nextController: currentWindow.rootViewController)
    }
    
    private class func  getNextXController(nextController: UIViewController?) -> UIViewController? {
        if nextController == nil {
            return nil
        } else if nextController?.presentedViewController != nil {
            return UIViewController.getNextXController(nextController: nextController?.presentedViewController)
        } else if let tabbar = nextController as? UITabBarController {
            return UIViewController.getNextXController(nextController: tabbar.selectedViewController)
        } else if let nav = nextController as? UINavigationController {
            return UIViewController.getNextXController(nextController: nav.visibleViewController)
        }
        return nextController
    }
}
