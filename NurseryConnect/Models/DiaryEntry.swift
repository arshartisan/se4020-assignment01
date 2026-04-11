//
//  DiaryEntry.swift
//  NurseryConnect
//
//  Represents a single observation logged by a keyworker for a child
//  during the day. Supports multiple entry types via the `type` enum.
//  Daily diary records satisfy EYFS observation duty. In production these
//  would carry `FileProtectionType.complete`.
//

import Foundation
import SwiftData

@Model
final class DiaryEntry {
    @Attribute(.unique) var id: UUID
    var child: Child?
    var typeRawValue: String              // Stored as raw to keep SwiftData happy
    var timestamp: Date
    var notes: String
    var loggedByKeyworker: String

    // Type-specific optional fields (only one set will be populated per entry)
    var activityName: String?             // for .activity
    var activityDurationMinutes: Int?     // for .activity
    var mealType: String?                 // for .meal — "breakfast", "lunch", "snack"
    var portionConsumed: String?          // for .meal — "all", "most", "half", "little", "none"
    var napStartTime: Date?               // for .nap
    var napEndTime: Date?                 // for .nap
    var nappyType: String?                // for .nappy — "wet", "dirty", "both"
    var moodRatingRawValue: String?       // for .wellbeing

    // MARK: - Computed
    var type: DiaryEntryType {
        get { DiaryEntryType(rawValue: typeRawValue) ?? .activity }
        set { typeRawValue = newValue.rawValue }
    }

    var moodRating: MoodRating? {
        get { moodRatingRawValue.flatMap(MoodRating.init(rawValue:)) }
        set { moodRatingRawValue = newValue?.rawValue }
    }

    init(
        id: UUID = UUID(),
        child: Child? = nil,
        type: DiaryEntryType,
        timestamp: Date = .now,
        notes: String = "",
        loggedByKeyworker: String
    ) {
        self.id = id
        self.child = child
        self.typeRawValue = type.rawValue
        self.timestamp = timestamp
        self.notes = notes
        self.loggedByKeyworker = loggedByKeyworker
    }
}
