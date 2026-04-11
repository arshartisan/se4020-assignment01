//
//  ChildRosterCard.swift
//  NurseryConnect
//

import SwiftUI

struct ChildRosterCard: View {
    let child: Child

    @State private var isPressed = false

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            // Name
            Text(child.firstName)
                .font(.appHeadline)
                .foregroundColor(.appTextPrimary)
                .lineLimit(1)

            // Age
            Text(formattedAge)
                .font(.appCaption)
                .foregroundColor(.appTextSecondary)

            // Room
            Text(child.roomName)
                .font(.appCaption)
                .foregroundColor(.appTextSecondary)
                .lineLimit(1)

            // Badges row
            HStack(spacing: AppSpacing.xs) {
                if !child.allergies.isEmpty {
                    allergyBadge
                }
                consentIndicator
                Spacer()
            }
        }
        .frame(minHeight: AppSpacing.minTapTarget)
        .cardStyle()
        .scaleEffect(isPressed ? 0.96 : 1.0)
        .animation(.easeInOut(duration: 0.15), value: isPressed)
        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }

    // MARK: - Subviews

    private var allergyBadge: some View {
        HStack(spacing: 2) {
            Image(systemName: AppIcons.warning)
                .font(.system(size: 10))
            Text("Allergy")
                .font(.system(size: 10, weight: .semibold))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 6)
        .padding(.vertical, 3)
        .background(Color.appDanger)
        .clipShape(Capsule())
    }

    private var consentIndicator: some View {
        Image(systemName: child.photographyConsent ? AppIcons.camera : "camera.fill")
            .font(.system(size: 12))
            .foregroundColor(child.photographyConsent ? .appSuccess : .appTextSecondary.opacity(0.4))
    }

    // MARK: - Helpers

    private var formattedAge: String {
        let months = child.ageInMonths
        let years = months / 12
        let remainingMonths = months % 12
        return "\(years)y \(remainingMonths)m"
    }
}
