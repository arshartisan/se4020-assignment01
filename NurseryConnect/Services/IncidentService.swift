//
//  IncidentService.swift
//  NurseryConnect
//
//  EYFS requires same-day parent notification; production system would
//  trigger this from the dispatch step.
//

import Foundation
import SwiftData

enum IncidentServiceError: LocalizedError {
    case missingDescription
    case missingAction
    case persistenceFailure(underlying: Error)

    var errorDescription: String? {
        switch self {
        case .missingDescription: return "Please describe what happened."
        case .missingAction:      return "Please record the action you took."
        case .persistenceFailure(let e): return "Could not save incident: \(e.localizedDescription)"
        }
    }
}

@MainActor
struct IncidentService {
    let context: ModelContext
    let dispatchService: MockDispatchService

    /// Submits an incident: validates → persists → simulates async dispatch to manager.
    func submit(_ incident: IncidentReport) async throws {
        try validate(incident)
        incident.submittedAt = .now
        context.insert(incident)
        do {
            try context.save()
        } catch {
            throw IncidentServiceError.persistenceFailure(underlying: error)
        }
        // Async dispatch — demonstrates async/await advanced concept
        let result = await dispatchService.dispatch(incidentID: incident.id)
        incident.dispatchStatus = result ? "dispatched" : "failed"
        try? context.save()
    }

    func allIncidents() throws -> [IncidentReport] {
        let descriptor = FetchDescriptor<IncidentReport>(
            sortBy: [SortDescriptor(\.occurredAt, order: .reverse)]
        )
        return try context.fetch(descriptor)
    }

    private func validate(_ incident: IncidentReport) throws {
        if incident.descriptionText.trimmingCharacters(in: .whitespaces).isEmpty {
            throw IncidentServiceError.missingDescription
        }
        if incident.immediateActionTaken.trimmingCharacters(in: .whitespaces).isEmpty {
            throw IncidentServiceError.missingAction
        }
    }
}
