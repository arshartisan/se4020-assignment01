//
//  QuickActionsBar.swift
//  NurseryConnect
//

import SwiftUI

struct QuickActionsBar: View {
    let onSelectType: (DiaryEntryType) -> Void
    var onReportIncident: () -> Void = {}

    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            Text("Quick Actions")
                .sectionHeaderStyle()

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 90), spacing: AppSpacing.sm)], spacing: AppSpacing.sm) {
                ForEach(DiaryEntryType.allCases) { type in
                    quickActionButton(for: type)
                }
                reportIncidentButton
            }
        }
    }

    private func quickActionButton(for type: DiaryEntryType) -> some View {
        Button {
            Haptics.light()
            onSelectType(type)
        } label: {
            VStack(spacing: AppSpacing.xs) {
                Image(systemName: type.sfSymbol)
                    .font(.title2)
                Text(type.displayName)
                    .font(.appCaption)
            }
            .frame(maxWidth: .infinity, minHeight: AppSpacing.minTapTarget)
            .padding(.vertical, AppSpacing.sm)
            .foregroundColor(.appPrimary)
            .background(Color.appPrimary.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.cornerRadius))
        }
        .buttonStyle(.plain)
    }

    private var reportIncidentButton: some View {
        Button {
            Haptics.medium()
            onReportIncident()
        } label: {
            VStack(spacing: AppSpacing.xs) {
                Image(systemName: AppIcons.incident)
                    .font(.title2)
                Text("Incident")
                    .font(.appCaption)
            }
            .frame(maxWidth: .infinity, minHeight: AppSpacing.minTapTarget)
            .padding(.vertical, AppSpacing.sm)
            .foregroundColor(.appDanger)
            .background(Color.appDanger.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.cornerRadius))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    QuickActionsBar { type in
        print("Selected \(type.displayName)")
    }
    .padding()
}
