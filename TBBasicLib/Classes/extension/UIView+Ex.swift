//
//  UIView+Ex.swift
//  TV Remote Control
//
//  Created by 陶博 on 2025/3/10.
//

import Foundation
import UIKit

public enum GradientDirection {
    case topToBottom, leftToRight, custom(startPoint: CGPoint, endPoint: CGPoint)
}

public extension UIView {
    
    /// 为视图添加内阴影
    /// - Parameters:
    ///   - shadowColor: 阴影颜色，默认黑色
    ///   - shadowOffset: 阴影偏移量，默认 (0, 2)
    ///   - shadowOpacity: 阴影透明度，默认 0.5
    ///   - shadowRadius: 阴影半径，默认 5
    func addInnerShadow(
        shadowColor: UIColor = .black,
        shadowOffset: CGSize = CGSize(width: 0, height: 2),
        shadowOpacity: Float = 0.5,
        shadowRadius: CGFloat = 5
    ) {
        
        let shadowLayer = CALayer()
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0, height: 2)
        shadowLayer.shadowOpacity = 0.5
        
        let shadowPath = UIBezierPath()
        shadowPath.move(to: CGPoint(x: 0, y: 0))
        shadowPath.addLine(to: CGPoint(x: self.bounds.width, y: 0))
        shadowPath.move(to: CGPoint(x: 0, y: self.bounds.height))
        shadowPath.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
        shadowLayer.shadowPath = shadowPath.cgPath
        self.layer.addSublayer(shadowLayer)
    }
    
    /// 设置渐变色背景（需在布局完成后调用）
    func setGradientBackground(_ colors: [UIColor] = [.white, .black]) {
        self.setGradientBackground(colors, startPoint: CGPoint(x: 0.25, y: 0.5), endPoint: CGPoint(x: 0.75, y: 0.5))
    }
    
    func setGradientBackground(_ colors: [UIColor], direction: GradientDirection = .leftToRight) {
        var startPoint: CGPoint = .zero
        var endPoint: CGPoint = .zero
        switch direction {
        case .topToBottom:
            startPoint = CGPoint(x: 0.5, y: 0.0)
            endPoint = CGPoint(x: 0.5, y: 1.0)
        case .leftToRight:
            startPoint = CGPoint(x: 0.25, y: 0.5)
            endPoint = CGPoint(x: 0.75, y: 0.5)
        case .custom(let startPointp, let endPointp):
            startPoint = startPointp
            endPoint = endPointp
        }
        self.setGradientBackground(colors, startPoint: startPoint, endPoint: endPoint)
    }
    
    /// 清除渐变色背景
    func removeGradientColor() {
        self.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
    }
    
    /// 设置渐变色背景（需在布局完成后调用）
    func setGradientBackground(_ colors: [UIColor],
                               startPoint: CGPoint = CGPoint(x: 0.25, y: 0.5),
                               endPoint: CGPoint = CGPoint(x: 0.75, y: 0.5),
                               locations: [NSNumber]? = nil) {
        layoutIfNeeded()
        let gradientLayer = CAGradientLayer()
        gradientLayer.locations = locations
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = layer.cornerRadius
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    /// 给底部添加阴影
    func addBottomShadow() {
        // 设置阴影的颜色
        self.layer.shadowColor = UIColor.white.withAlphaComponent(0.1).cgColor
        
        // 设置阴影的透明度
        self.layer.shadowOpacity = 1
        
        // 设置阴影的半径
        self.layer.shadowRadius = 5
        
        // 设置阴影的偏移量：偏移量的高度设置为正值，使阴影出现在底部
        self.layer.shadowOffset = CGSize(width: 0, height: 5) // 横向偏移量 0，纵向偏移量 5
        
        // 仅在底部添加阴影，使用 shadowPath 来精确控制
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: self.bounds.height - 4, width: self.bounds.width, height: 4))
        self.layer.shadowPath = shadowPath.cgPath
    }
    
    func removeShadow() {
        // 移除阴影的颜色
        self.layer.shadowColor = nil
        
        // 移除阴影的透明度
        self.layer.shadowOpacity = 0
        
        // 移除阴影的半径
        self.layer.shadowRadius = 0
        
        // 移除阴影的偏移量
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        // 移除阴影的路径
        self.layer.shadowPath = nil
    }
    
    func addCornerRadius(_ cornerRadius: Double) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = cornerRadius
    }
    
    func removeAllSubview() {
        self.subviews.forEach { $0.removeFromSuperview() }
    }
    
    /// 找到view所在的vc
    /// - Returns: vc
    func viewController() -> UIViewController? {
        for view in sequence(first: self.superview, next: {$0?.superview}) {
            if let responder = view?.next {
                if responder.isKind(of: UIViewController.self) {
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
    
    /// 给view添加指定圆角
    /// - Parameters:
    ///   - radius: 圆角大小
    ///   - corners: 圆角位置
    func addCornerRadius(_ radius: CGFloat, corners: UIRectCorner) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
}
