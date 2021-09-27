//
//  ViewExtensions.swift
//  BudgetBuddy
//
//  Created by Tino on 27/9/21.
//

import SwiftUI

struct Card: ViewModifier {
    /// The radius for the cards corners.
    let radius: Double
    /// The opacity for the cards background.
    private let opacity = 0.5
    
    func body(content: Content) -> some View {
        ZStack {
            Color("lightBlue").opacity(opacity)
            content
        }
        .cornerRadius(radius)
    }
}

extension View {
    func card(radius: Double = 16) -> some View {
        modifier(Card(radius: radius))
    }
}
