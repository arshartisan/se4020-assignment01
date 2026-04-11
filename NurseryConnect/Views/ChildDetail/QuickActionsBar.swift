//
//  QuickActionsBar.swift
//  NurseryConnect
//

import SwiftUI

struct QuickActionsBar: View {
    let onSelectType: (DiaryEntryType) -> Void
    var onReportIncident: () -> Void = {}

    @State private var appeared = false

    private let columns = [
        GridItem(.flexible(), spacing: AppSpacing.sm),
        GridItem(.flexible(), spacing: AppSpacing.sm),
        GridItem(.flexible(), spacing: AppSpacing.sm)
    ]

    /// Pastel tile colors for each action type.
    private func tileColor(for type: DiaryEntryType) -> Color {
        switch type {
        case .activity:  return Color(red: 0.95, green: 0.82, blue: 0.60) // warm yellow
        case .meal:      return Color(red: 0.75, green: 0.88, blue: 0.72) // soft green
        case .nap:       return Color(red: 0.76, green: 0.82, blue: 0.95) // soft blue
        case .nappy:     return Color(red: 0.90, green: 0.78, blue: 0.92) // soft purple
        case .wellbeing: return Color(red: 0.95, green: 0.80, blue: 0.78) // soft pink
        }
    }

    var body: some View {
        LazyVGrid(columns: columns, spacing: AppSpacing.sm) {
            ForEach(Array(DiaryEntryType.allCases.enumerated()), id: \.element) { index, type in
                actionTile(for: type, delay: Double(index) * 0.05)
            }
            incidentTile
        }
        .onAppear { appeared = true }
    }

    private func actionTile(for type: DiaryEntryType, delay: Double) -> some View {
        Button {
            Haptics.light()
            onSelectType(type)
        } label: {
            VStack(spacing: AppSpacing.sm) {
                Image(systemName: type.sfSymbol)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.black.opacity(0.55))
                Text(type.displayName)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black.opacity(0.6))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 90)
            .background(tileColor(for: type).opacity(0.55))
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.cornerRadius))
        }
        .buttonStyle(.plain)
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 10)
        .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(delay), value: appeared)
        .accessibilityIdentifier("quickAction.\(type.rawValue)")
    }

    private var incidentTile: some View {
        Button {
            Haptics.medium()
            onReportIncident()
        } label: {
            VStack(spacing: AppSpacing.sm) {
                Image(systemName: AppIcons.incident)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.appDanger.opacity(0.8))
                Text("Incident")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(.appDanger.opacity(0.8))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 90)
            .background(Color.appDanger.opacity(0.10))
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.cornerRadius))
        }
        .buttonStyle(.plain)
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 10)
        .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(Double(DiaryEntryType.allCases.count) * 0.05), value: appeared)
        .accessibilityIdentifier("quickAction.reportIncident")
    }
}

#Preview {
    QuickActionsBar { type in
        print("Selected \(type.displayName)")
    }
    .padding()
}
