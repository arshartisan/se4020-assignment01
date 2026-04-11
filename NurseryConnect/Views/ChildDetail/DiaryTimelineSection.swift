//
//  DiaryTimelineSection.swift
//  NurseryConnect
//

import SwiftUI

struct DiaryTimelineSection: View {
    let entries: [DiaryEntry]

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Today's Diary")
                .sectionHeaderStyle()

            LazyVStack(spacing: AppSpacing.sm) {
                ForEach(entries) { entry in
                    DiaryEntryRow(entry: entry)
                }
            }
        }
    }
}
