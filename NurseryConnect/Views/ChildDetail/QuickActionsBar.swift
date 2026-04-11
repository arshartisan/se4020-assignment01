//
//  QuickActionsBar.swift
//  NurseryConnect
//

import SwiftUI

struct QuickActionsBar: View {
    let onSelectType: (DiaryEntryType) -> Void
    var onReportIncident: () -> Void = {}

    @State private var appeared = false

    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            Text("Quick Actions")
                .sectionHeaderStyle()

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 90), spacing: AppSpacing.sm)], spacing: AppSpacing.sm) {
                ForEach(Array(DiaryEntryType.allCases.enumerated()), id: \.element) { index, type in
                    quickActionButton(for: type)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 10)
                        .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(Double(index) * 0.05), value: appeared)
                }
                reportIncidentButton
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(Double(DiaryEntryType.allCases.count) * 0.05), value: appeared)
            }
        }
        .onAppear { appeared = true }
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
        .accessibilityIdentifier("quickAction.\(type.rawValue)")
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
        .accessibilityIdentifier("quickAction.reportIncident")
    }
}

#Preview {
    QuickActionsBar { type in
        print("Selected \(type.displayName)")
    }
    .padding()
}
