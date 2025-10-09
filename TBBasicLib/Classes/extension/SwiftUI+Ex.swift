//
//  File.swift
//  TBBasicLib
//
//  Created by 陶博 on 2025/10/9.
//

import Foundation
import SwiftUI

/// 添加指定圆角
public struct RoundedCorner: Shape {
    public var radius: CGFloat = .infinity
    public var corners: UIRectCorner = .allCorners

    public init(radius: CGFloat, corners: UIRectCorner = .allCorners) {
        self.radius = radius
        self.corners = corners
    }
    
    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

public extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner = .allCorners, color: Color = .clear, lineWidth: CGFloat = 0.0) -> some View {
        RoundedCorner(radius: radius, corners: corners)
            .stroke(color, lineWidth: lineWidth)
    }
}
