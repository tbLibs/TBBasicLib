//
//  TBBaseTabBarController.swift
//  TV Remote Control
//
//  Created by 陶博 on 2025/3/10.
//

import UIKit

public class TBTabBarVCModel: NSObject {
    
    public var vc = UIViewController()
    
    public var title = ""
    
    public var normalImage = UIImage()
    
    public var selectedImage = UIImage()
    
    public var navType: UINavigationController.Type = UINavigationController.self
    
    public init(vc: UIViewController = UIViewController(), title: String = "", normalImage: UIImage = UIImage(), selectedImage: UIImage = UIImage(), navType: UINavigationController.Type) {
        self.vc = vc
        self.title = title
        self.normalImage = normalImage
        self.selectedImage = selectedImage
        self.navType = navType
    }
    
}

open class TBBaseTabBarController: UITabBarController {
    
    open var selectVCIndex = 0

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置 tabBar 的背景色
        if #available(iOS 15.0, *) {
            
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground() // 或 configureWithDefaultBackground()
            
            // 设置背景颜色
            appearance.backgroundColor = tabBarBackgroundColor
            
            // 设置未选中状态文字属性
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .font: textNormalFont,
                .foregroundColor: textNormalColor
            ]
            
            // 设置选中状态文字属性（如有需要）
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .font: textSelectedFont,
                .foregroundColor: textSelectedColor
            ]
            
            // 应用到 tabBar 上
            self.tabBar.standardAppearance = appearance
            self.tabBar.scrollEdgeAppearance = appearance
        } else {
            self.tabBar.backgroundColor = tabBarBackgroundColor
            self.tabBar.barTintColor = tabBarBackgroundColor
            // iOS 15 以下版本继续使用旧方法
            // 自定义默认的样式
            UITabBarItem.appearance().setTitleTextAttributes([.font: textNormalFont, .foregroundColor: textNormalColor], for: .normal)
            // 自定义选中的样式
            UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: textSelectedColor], for: .selected)
        }
        addChildVC()
    }
    
    
    /// 添加vc
    func addChildVC() {
        var vcs = [UIViewController]()
        
        for item in tabBarViewControllers {
            let vc = item.vc
            let tabbarItem = UITabBarItem(title: item.title, image: item.normalImage.withRenderingMode(.alwaysOriginal), selectedImage: item.selectedImage.withRenderingMode(.alwaysOriginal))
            vc.tabBarItem = tabbarItem
            let nav = item.navType.init(rootViewController: vc)
            vcs.append(nav)
        }
        self.setViewControllers(vcs, animated: true)
        self.selectedIndex = 0
    }
    

}


extension TBBaseTabBarController: TBTabBarable {
    
    open var tabBarBackgroundColor: UIColor { .clear }
    
    open var textNormalFont: UIFont { .systemFont(ofSize: 12) }
    
    open var textSelectedFont: UIFont { .systemFont(ofSize: 12) }
    
    open var textNormalColor: UIColor { .clear }
    
    open var textSelectedColor: UIColor { .clear }
    
    open var tabBarViewControllers: [TBTabBarVCModel] { [] }
}
