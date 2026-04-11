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
        VStack(spacing: AppSpacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 36))
                .foregroundColor(.appTextSecondary.opacity(0.6))
                .accessibilityHidden(true)

            Text(title)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.appTextPrimary)
                .tracking(-1.5)

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
        title: "No entries yet",
        subtitle: "Tap the + button to add a new diary entry."
    )
}
