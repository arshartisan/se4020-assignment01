//
//  DiaryEntryRow.swift
//  NurseryConnect
//

import SwiftUI

struct DiaryEntryRow: View {
    let entry: DiaryEntry

    /// Pastel accent per entry type.
    private var accentColor: Color {
        switch entry.type {
        case .activity:  return Color(red: 0.95, green: 0.82, blue: 0.60)
        case .meal:      return Color(red: 0.75, green: 0.88, blue: 0.72)
        case .nap:       return Color(red: 0.76, green: 0.82, blue: 0.95)
        case .nappy:     return Color(red: 0.90, green: 0.78, blue: 0.92)
        case .wellbeing: return Color(red: 0.95, green: 0.80, blue: 0.78)
        }
    }

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(accentColor.opacity(0.5))
                    .frame(width: 40, height: 40)
                Image(systemName: entry.type.sfSymbol)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black.opacity(0.55))
                    .accessibilityHidden(true)
            }

            // Content
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(entry.type.displayName)
                        .font(.appHeadline)
                        .foregroundColor(.appTextPrimary)
                    Spacer()
                    Text(entry.timestamp.timeFormatted())
                        .font(.caption2)
                        .foregroundColor(.appTextSecondary)
                }

                typeSpecificContent

                if !entry.notes.isEmpty {
                    Text(entry.notes)
                        .font(.appCaption)
                        .foregroundColor(.appTextSecondary)
                        .lineLimit(2)
                }
            }
        }
        .padding(AppSpacing.md)
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.cornerRadius))
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
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
                Text("\(start.timeFormatted()) \u{2013} \(end.timeFormatted())")
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
