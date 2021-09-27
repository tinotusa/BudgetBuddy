//
//  CustomRoundedRectangle.swift
//  BudgetBuddy
//
//  Created by Tino on 26/9/21.
//

import SwiftUI

struct CustomRoundedRectangle: Shape {
    let corners: UIRectCorner
    let radius: Double
    
    func path(in rect: CGRect) -> Path {
        let roundedRect = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(roundedRect.cgPath)
    }
}
