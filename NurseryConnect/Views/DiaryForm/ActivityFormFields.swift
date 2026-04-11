//
//  ActivityFormFields.swift
//  NurseryConnect
//

import SwiftUI

struct ActivityFormFields: View {
    @Binding var activityName: String
    @Binding var durationMinutes: Int

    var body: some View {
        VStack(spacing: AppSpacing.md) {
            HStack(spacing: AppSpacing.md) {
                ZStack {
                    Circle()
                        .fill(Color.appPrimary.opacity(0.1))
                        .frame(width: 36, height: 36)
                    Image(systemName: "figure.play")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.appPrimary)
                }

                TextField("Activity name", text: $activityName)
                    .font(.appBody)
            }

            Divider()
                .padding(.leading, 52)

            HStack(spacing: AppSpacing.md) {
                ZStack {
                    Circle()
                        .fill(Color.appWarning.opacity(0.1))
                        .frame(width: 36, height: 36)
                    Image(systemName: "timer")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.appWarning)
                }

                Stepper("Duration: \(durationMinutes) min", value: $durationMinutes, in: 5...180, step: 5)
                    .font(.appBody)
            }
        }
    }
}
