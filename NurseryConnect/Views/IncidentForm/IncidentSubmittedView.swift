//
//  IncidentSubmittedView.swift
//  NurseryConnect
//

import SwiftUI

struct IncidentSubmittedView: View {
    let onDismiss: () -> Void

    @State private var showContent = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            VStack(spacing: AppSpacing.lg) {
                Image(systemName: AppIcons.checkmark)
                    .font(.system(size: 60))
                    .foregroundColor(.appSuccess)
                    .symbolEffect(.bounce, value: showContent)

                Text("Incident Report Submitted")
                    .font(.appTitle)
                    .foregroundColor(.appTextPrimary)
                    .multilineTextAlignment(.center)

                Text("The report has been dispatched to the setting manager.")
                    .font(.appBody)
                    .foregroundColor(.appTextSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(AppSpacing.xl)
            .background(Color.appSurface)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.cardCornerRadius))
            .shadow(radius: 20)
            .padding(AppSpacing.xl)
            .scaleEffect(showContent ? 1.0 : 0.8)
            .opacity(showContent ? 1.0 : 0.0)
            .accessibilityIdentifier("incidentSubmitted")
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                showContent = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                onDismiss()
            }
        }
    }
}

#Preview {
    IncidentSubmittedView {
        print("Dismissed")
    }
}
