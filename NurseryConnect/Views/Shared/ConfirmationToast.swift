//
//  ConfirmationToast.swift
//  NurseryConnect
//

import SwiftUI

struct ConfirmationToast: View {
    let message: String
    @Binding var isShowing: Bool

    var body: some View {
        if isShowing {
            VStack {
                HStack(spacing: AppSpacing.sm) {
                    Image(systemName: AppIcons.success)
                        .foregroundColor(.appSuccess)
                        .accessibilityHidden(true)
                    Text(message)
                        .font(.appBody)
                        .foregroundColor(.appTextPrimary)
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.vertical, AppSpacing.md)
                .background(Color.appSurface)
                .clipShape(RoundedRectangle(cornerRadius: AppSpacing.cornerRadius))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
                .transition(.move(edge: .top).combined(with: .opacity))
                .accessibilityIdentifier("confirmationToast")

                Spacer()
            }
            .padding(.top, AppSpacing.md)
            .animation(.spring(), value: isShowing)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation { isShowing = false }
                }
            }
        }
    }
}

#Preview {
    ConfirmationToast(message: "Entry saved successfully", isShowing: .constant(true))
}
