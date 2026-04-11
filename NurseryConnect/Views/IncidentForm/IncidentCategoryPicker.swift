//
//  IncidentCategoryPicker.swift
//  NurseryConnect
//

import SwiftUI

struct IncidentCategoryPicker: View {
    @Binding var selected: IncidentCategory

    private let columns = [
        GridItem(.adaptive(minimum: 100), spacing: AppSpacing.sm)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: AppSpacing.sm) {
            ForEach(IncidentCategory.allCases) { category in
                categoryButton(for: category)
            }
        }
    }

    private func categoryButton(for category: IncidentCategory) -> some View {
        let isSelected = selected == category
        return Button {
            selected = category
        } label: {
            VStack(spacing: AppSpacing.xs) {
                Image(systemName: category.sfSymbol)
                    .font(.title2)
                Text(category.displayName)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, minHeight: AppSpacing.minTapTarget + 20)
            .padding(.vertical, AppSpacing.sm)
            .foregroundColor(isSelected ? .appDanger : .appTextSecondary)
            .background(isSelected ? Color.appDanger.opacity(0.12) : Color.appSurface)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: AppSpacing.cornerRadius)
                    .stroke(isSelected ? Color.appDanger : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(category.displayName)\(isSelected ? ", selected" : "")")
    }
}

#Preview {
    @Previewable @State var category: IncidentCategory = .minorAccident
    IncidentCategoryPicker(selected: $category)
        .padding()
}
