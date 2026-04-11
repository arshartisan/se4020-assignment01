//
//  DiaryService.swift
//  NurseryConnect
//

import Foundation
import SwiftData

enum DiaryServiceError: LocalizedError {
    case invalidEntry(reason: String)
    case persistenceFailure(underlying: Error)

    var errorDescription: String? {
        switch self {
        case .invalidEntry(let reason):
            return "Diary entry is invalid: \(reason)"
        case .persistenceFailure(let error):
            return "Could not save diary entry: \(error.localizedDescription)"
        }
    }
}

@MainActor
struct DiaryService {
    let context: ModelContext

    /// Saves a new diary entry. Throws if validation or persistence fails.
    func save(_ entry: DiaryEntry) async throws {
        try validate(entry)
        context.insert(entry)
        do {
            try context.save()
        } catch {
            throw DiaryServiceError.persistenceFailure(underlying: error)
        }
    }

    /// Fetches all entries for a given child, newest first.
    func entries(for child: Child) throws -> [DiaryEntry] {
        let childID = child.id
        let descriptor = FetchDescriptor<DiaryEntry>(
            predicate: #Predicate { $0.child?.id == childID },
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        return try context.fetch(descriptor)
    }

    // MARK: - Validation
    private func validate(_ entry: DiaryEntry) throws {
        if entry.notes.isEmpty && entry.type == .activity && (entry.activityName?.isEmpty ?? true) {
            throw DiaryServiceError.invalidEntry(reason: "Activity name or notes required.")
        }
        if entry.type == .meal && (entry.mealType?.isEmpty ?? true) {
            throw DiaryServiceError.invalidEntry(reason: "Meal type required.")
        }
        if entry.type == .nap, let start = entry.napStartTime, let end = entry.napEndTime, end < start {
            throw DiaryServiceError.invalidEntry(reason: "Nap end time cannot be before start time.")
        }
    }
}
