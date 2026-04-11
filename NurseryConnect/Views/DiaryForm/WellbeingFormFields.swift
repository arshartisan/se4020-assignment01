//
//  WellbeingFormFields.swift
//  NurseryConnect
//

import SwiftUI

struct WellbeingFormFields: View {
    @Binding var moodRating: MoodRating?

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("How is the child feeling?")
                .font(.appBody)
                .foregroundColor(.appTextSecondary)

            HStack(spacing: AppSpacing.md) {
                ForEach(MoodRating.allCases) { mood in
                    moodButton(for: mood)
                }
            }
        }
    }

    private func moodButton(for mood: MoodRating) -> some View {
        Button {
            moodRating = mood
        } label: {
            VStack(spacing: AppSpacing.xs) {
                Text(mood.emoji)
                    .font(.title)
                Text(mood.displayName)
                    .font(.caption2)
                    .foregroundColor(.appTextSecondary)
            }
            .frame(maxWidth: .infinity, minHeight: AppSpacing.minTapTarget)
            .background(moodRating == mood ? Color.appPrimary.opacity(0.15) : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.cornerRadius / 2))
            .overlay(
                RoundedRectangle(cornerRadius: AppSpacing.cornerRadius / 2)
                    .stroke(moodRating == mood ? Color.appPrimary : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(mood.displayName)\(moodRating == mood ? ", selected" : "")")
    }
}
