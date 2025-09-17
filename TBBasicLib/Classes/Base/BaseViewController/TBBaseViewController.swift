//
//  TBBaseViewController.swift
//  TBBasicLib
//
//  Created by 陶博 on 2025/5/8.
//

import UIKit
import Foundation


open class TBBaseViewController: UIViewController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
    }
    
    /// pop上个页面
    open func goBack() {
        if self.navigationController?.viewControllers.count == 1 {
            self.dismiss(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    open func popGestureClose() {
        if let ges = self.navigationController?.interactivePopGestureRecognizer?.view?.gestureRecognizers {
            for item in ges {
                item.isEnabled = false
            }
        }
    }
    
    open func popGestureOpen() {
        if let ges = self.navigationController?.interactivePopGestureRecognizer?.view?.gestureRecognizers {
            for item in ges {
                item.isEnabled = true
            }
        }
    }
    
}
// MARK: UIGestureRecognizerDelegate
extension TBBaseViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}

