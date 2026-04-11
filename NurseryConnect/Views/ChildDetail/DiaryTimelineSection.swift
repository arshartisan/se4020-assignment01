//
//  DiaryTimelineSection.swift
//  NurseryConnect
//

import SwiftUI

struct DiaryTimelineSection: View {
    let entries: [DiaryEntry]

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack {
                Text("Today's Diary")
                    .font(.appHeadline)
                    .foregroundColor(.appTextPrimary)
                Spacer()
                Text("\(entries.count) entries")
                    .font(.appCaption)
                    .foregroundColor(.appTextSecondary)
            }
            .padding(.horizontal, AppSpacing.xs)

            LazyVStack(spacing: AppSpacing.sm) {
                ForEach(entries) { entry in
                    DiaryEntryRow(entry: entry)
                }
            }
        }
    }
}
