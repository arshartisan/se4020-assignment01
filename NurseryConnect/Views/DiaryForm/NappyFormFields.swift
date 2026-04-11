//
//  NappyFormFields.swift
//  NurseryConnect
//

import SwiftUI

struct NappyFormFields: View {
    @Binding var nappyType: String

    private let nappyTypes = ["wet", "dirty", "both"]

    var body: some View {
        VStack(spacing: AppSpacing.md) {
            HStack(spacing: AppSpacing.md) {
                ZStack {
                    Circle()
                        .fill(Color.appPrimary.opacity(0.1))
                        .frame(width: 36, height: 36)
                    Image(systemName: "drop.fill")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.appPrimary)
                }

                Text("Type")
                    .font(.appBody)
                    .foregroundColor(.appTextSecondary)

                Spacer()
            }

            HStack(spacing: AppSpacing.sm) {
                ForEach(nappyTypes, id: \.self) { type in
                    nappyChip(for: type)
                }
            }
        }
    }

    private func nappyChip(for type: String) -> some View {
        let isSelected = nappyType == type
        return Button {
            nappyType = type
        } label: {
            Text(type.capitalized)
                .font(.appCaption)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, minHeight: 36)
                .background(isSelected ? Color.appPrimary : Color.appBackground)
                .foregroundColor(isSelected ? .white : .appTextSecondary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
