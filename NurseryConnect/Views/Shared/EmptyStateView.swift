//
//  EmptyStateView.swift
//  NurseryConnect
//

import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundColor(.appTextSecondary.opacity(0.6))
                .accessibilityHidden(true)

            Text(title)
                .font(.appTitle)
                .foregroundColor(.appTextPrimary)

            Text(subtitle)
                .font(.appBody)
                .foregroundColor(.appTextSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(AppSpacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EmptyStateView(
        icon: AppIcons.empty,
        title: "No Entries Yet",
        subtitle: "Tap the + button to add a new diary entry."
    )
}
