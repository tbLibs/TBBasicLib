//
//  TRCAlertView.swift
//  TV Remote Control
//
//  Created by 陶博 on 2025/3/13.
//

import Foundation
import UIKit


class TRCAlertView {
    
    static func showAlert(title: String? = nil,
                          message: String? =  nil,
                          viewController: UIViewController? = UIViewController.getCurrentViewController(),
                          okCallBack: ((UIAlertAction) -> Void)? = nil,
                          cancelCallBack: ((UIAlertAction) -> Void)? = nil) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let act1 = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelCallBack)
        let act2 = UIAlertAction(title: "OK", style: .default, handler: okCallBack)
        ac.addAction(act1)
        ac.addAction(act2)
        viewController?.present(ac, animated: true)
    }
    
    static func showTextFieldAlert(title: String? = nil,
                                   message: String? =  nil,
                                   viewController: UIViewController? = UIViewController.getCurrentViewController(),
                                   okCallBack: ((_ code: String) -> Void)? = nil,
                                   cancelCallBack: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addTextField()
        let act1 = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelCallBack)
        let act2 = UIAlertAction(title: "OK", style: .default) { _ in
            let str = ac.textFields?.first?.text
            okCallBack?(str ?? "")
        }
        ac.addAction(act1)
        ac.addAction(act2)
        viewController?.present(ac, animated: true)
        return ac
    }
    
}
