//
//  PrimaryButtonStyle.swift
//  NurseryConnect
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.appHeadline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, minHeight: AppSpacing.minTapTarget)
            .background(Color.appPrimary)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.cornerRadius))
            .opacity(configuration.isPressed ? 0.85 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle { PrimaryButtonStyle() }
}
