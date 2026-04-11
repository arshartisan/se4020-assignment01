//
//  MealFormFields.swift
//  NurseryConnect
//

import SwiftUI

struct MealFormFields: View {
    @Binding var mealType: String
    @Binding var portionConsumed: String

    private let mealTypes = ["breakfast", "lunch", "snack", "tea"]
    private let portions = ["all", "most", "half", "little", "none"]

    var body: some View {
        VStack(spacing: AppSpacing.md) {
            HStack(spacing: AppSpacing.md) {
                ZStack {
                    Circle()
                        .fill(Color.appSuccess.opacity(0.1))
                        .frame(width: 36, height: 36)
                    Image(systemName: "fork.knife")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.appSuccess)
                }

                Picker("Meal", selection: $mealType) {
                    Text("Select").tag("")
                    ForEach(mealTypes, id: \.self) { type in
                        Text(type.capitalized).tag(type)
                    }
                }
                .font(.appBody)
            }

            Divider()
                .padding(.leading, 52)

            HStack(spacing: AppSpacing.md) {
                ZStack {
                    Circle()
                        .fill(Color.appWarning.opacity(0.1))
                        .frame(width: 36, height: 36)
                    Image(systemName: "chart.pie.fill")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.appWarning)
                }

                Picker("Portion eaten", selection: $portionConsumed) {
                    Text("Select").tag("")
                    ForEach(portions, id: \.self) { portion in
                        Text(portion.capitalized).tag(portion)
                    }
                }
                .font(.appBody)
            }
        }
    }
}
