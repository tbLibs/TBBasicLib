//
//  SwiftUIable.swift
//  ins
//
//  Created by 陶博 on 2025/8/8.
//

import Foundation
import SwiftUI

protocol SwiftUIable {
    
    /// 为UIKit的VC设置swiftUI页面
    /// - Parameter swiftUIView: swiftUI的页面
    func setSwiftUIView<Content: View>(swiftUIView: Content)
    
}

extension SwiftUIable where Self: UIViewController {
    
    func setSwiftUIView<Content: View>(swiftUIView: Content) {
        let hostingController = UIHostingController(rootView: swiftUIView)
        hostingController.view.frame = view.bounds
        // 添加为子控制器
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
}
