//
//  DiaryEntryRow.swift
//  NurseryConnect
//

import SwiftUI

struct DiaryEntryRow: View {
    let entry: DiaryEntry

    var body: some View {
        HStack(alignment: .top, spacing: AppSpacing.md) {
            // Timeline indicator
            VStack(spacing: AppSpacing.xs) {
                Image(systemName: entry.type.sfSymbol)
                    .font(.body)
                    .foregroundColor(.appPrimary)
                    .frame(width: 32, height: 32)
                    .background(Color.appPrimary.opacity(0.1))
                    .clipShape(Circle())

                Rectangle()
                    .fill(Color.appTextSecondary.opacity(0.2))
                    .frame(width: 2)
            }
            .frame(width: 32)

            // Content
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                HStack {
                    Text(entry.type.displayName)
                        .font(.appHeadline)
                        .foregroundColor(.appTextPrimary)
                    Spacer()
                    Text(entry.timestamp.timeFormatted())
                        .font(.appCaption)
                        .foregroundColor(.appTextSecondary)
                }

                typeSpecificContent

                if !entry.notes.isEmpty {
                    Text(entry.notes)
                        .font(.appBody)
                        .foregroundColor(.appTextSecondary)
                        .lineLimit(3)
                }
            }
            .padding(AppSpacing.sm)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.appSurface)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.cornerRadius / 2))
        }
    }

    @ViewBuilder
    private var typeSpecificContent: some View {
        switch entry.type {
        case .activity:
            if let name = entry.activityName, !name.isEmpty {
                HStack(spacing: AppSpacing.xs) {
                    Text(name)
                    if let mins = entry.activityDurationMinutes {
                        Text("\u{00B7} \(mins) min")
                    }
                }
                .font(.appCaption)
                .foregroundColor(.appTextSecondary)
            }
        case .meal:
            if let meal = entry.mealType {
                HStack(spacing: AppSpacing.xs) {
                    Text(meal.capitalized)
                    if let portion = entry.portionConsumed {
                        Text("\u{00B7} ate \(portion)")
                    }
                }
                .font(.appCaption)
                .foregroundColor(.appTextSecondary)
            }
        case .nap:
            if let start = entry.napStartTime, let end = entry.napEndTime {
                Text("\(start.timeFormatted()) – \(end.timeFormatted())")
                    .font(.appCaption)
                    .foregroundColor(.appTextSecondary)
            }
        case .nappy:
            if let type = entry.nappyType {
                Text(type.capitalized)
                    .font(.appCaption)
                    .foregroundColor(.appTextSecondary)
            }
        case .wellbeing:
            if let mood = entry.moodRating {
                Text("\(mood.emoji) \(mood.displayName)")
                    .font(.appCaption)
                    .foregroundColor(.appTextSecondary)
            }
        }
    }
}
