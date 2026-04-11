//
//  NapFormFields.swift
//  NurseryConnect
//

import SwiftUI

struct NapFormFields: View {
    @Binding var startTime: Date
    @Binding var endTime: Date

    var body: some View {
        VStack(spacing: AppSpacing.md) {
            HStack(spacing: AppSpacing.md) {
                ZStack {
                    Circle()
                        .fill(Color.appPrimary.opacity(0.1))
                        .frame(width: 36, height: 36)
                    Image(systemName: "moon.zzz.fill")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.appPrimary)
                }

                DatePicker("Start time", selection: $startTime, displayedComponents: .hourAndMinute)
                    .font(.appBody)
            }

            Divider()
                .padding(.leading, 52)

            HStack(spacing: AppSpacing.md) {
                ZStack {
                    Circle()
                        .fill(Color.appSuccess.opacity(0.1))
                        .frame(width: 36, height: 36)
                    Image(systemName: "sun.max.fill")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.appSuccess)
                }

                DatePicker("End time", selection: $endTime, displayedComponents: .hourAndMinute)
                    .font(.appBody)
            }
        }
    }
}
