//
//  DiaryEntryFormViewModel.swift
//  NurseryConnect
//

import Foundation
import Observation

@Observable
@MainActor
final class DiaryEntryFormViewModel {
    // MARK: - Common fields
    var selectedType: DiaryEntryType
    var timestamp: Date = .now
    var notes: String = ""

    // MARK: - Activity fields
    var activityName: String = ""
    var activityDurationMinutes: Int = 15

    // MARK: - Meal fields
    var mealType: String = ""
    var portionConsumed: String = ""

    // MARK: - Nap fields
    var napStartTime: Date = .now
    var napEndTime: Date = .now.addingTimeInterval(3600)

    // MARK: - Nappy fields
    var nappyType: String = ""

    // MARK: - Wellbeing fields
    var moodRating: MoodRating?

    // MARK: - State
    var validationError: String?
    var isSaving: Bool = false
    var errorMessage: String?
    var didSave: Bool = false

    // MARK: - Dependencies
    private let child: Child
    private let diaryService: DiaryService
    private let keyworkerName: String

    init(child: Child, diaryService: DiaryService, selectedType: DiaryEntryType, keyworkerName: String = "Sarah Mitchell") {
        self.child = child
        self.diaryService = diaryService
        self.selectedType = selectedType
        self.keyworkerName = keyworkerName
    }

    // MARK: - Validation
    var isValid: Bool {
        switch selectedType {
        case .activity:
            return !activityName.trimmingCharacters(in: .whitespaces).isEmpty || !notes.trimmingCharacters(in: .whitespaces).isEmpty
        case .meal:
            return !mealType.isEmpty
        case .nap:
            return napEndTime > napStartTime
        case .nappy:
            return !nappyType.isEmpty
        case .wellbeing:
            return moodRating != nil
        }
    }

    // MARK: - Save
    func saveEntry() async {
        validationError = nil
        guard isValid else {
            validationError = "Please fill in all required fields."
            return
        }

        isSaving = true
        defer { isSaving = false }

        let entry = DiaryEntry(
            child: child,
            type: selectedType,
            timestamp: timestamp,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
            loggedByKeyworker: keyworkerName
        )

        switch selectedType {
        case .activity:
            entry.activityName = activityName.trimmingCharacters(in: .whitespaces)
            entry.activityDurationMinutes = activityDurationMinutes
        case .meal:
            entry.mealType = mealType
            entry.portionConsumed = portionConsumed
        case .nap:
            entry.napStartTime = napStartTime
            entry.napEndTime = napEndTime
        case .nappy:
            entry.nappyType = nappyType
        case .wellbeing:
            entry.moodRating = moodRating
        }

        do {
            try await diaryService.save(entry)
            Haptics.success()
            didSave = true
        } catch {
            Haptics.error()
            errorMessage = error.localizedDescription
        }
    }
}
