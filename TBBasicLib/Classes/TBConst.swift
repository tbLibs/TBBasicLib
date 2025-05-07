//
//  TBConst.swift
//  TV Remote Control
//
//  Created by 陶博 on 2025/3/10.
//

import Foundation
import UIKit

let KWidth = UIScreen.main.bounds.width
let KHeight = UIScreen.main.bounds.height

/// 判断是否是iPhone
let isIPhone = UIDevice.current.deviceTypeIsIphone()

/// 获取 window
let KWindow: UIWindow? = {
    if #available(iOS 13.0, *) {
        return UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    } else {
        return UIApplication.shared.keyWindow
    }
}()

/// 获取状态栏高度
let KStatusBarHeight: CGFloat = {
    if #available(iOS 13.0, *) {
        return UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .statusBarManager?.statusBarFrame.height ?? 0
    } else {
        return UIApplication.shared.statusBarFrame.height
    }
}()

/// 获取底部安全距离
let KBottomHeight: CGFloat = {
    if #available(iOS 13.0, *) {
        return UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .safeAreaInsets.bottom ?? 0
    } else {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        } else {
            return 0
        }
    }
}()


