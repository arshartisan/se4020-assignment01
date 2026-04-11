//
//  CardStyle.swift
//  NurseryConnect
//

import SwiftUI

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(AppSpacing.md)
            .background(Color.appSurface)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.cardCornerRadius))
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}
