//
//  IncidentHistoryViewModel.swift
//  NurseryConnect
//

import Foundation
import Observation

enum IncidentFilterOption: String, CaseIterable, Identifiable {
    case all
    case today
    case thisWeek

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .all:      return "All"
        case .today:    return "Today"
        case .thisWeek: return "This Week"
        }
    }
}

@Observable
@MainActor
final class IncidentHistoryViewModel {
    // MARK: - State
    var incidents: [IncidentReport] = []
    var filterOption: IncidentFilterOption = .all
    var isLoading: Bool = false
    var errorMessage: String?

    // MARK: - Dependencies
    private let incidentService: IncidentService

    init(incidentService: IncidentService) {
        self.incidentService = incidentService
    }

    // MARK: - Computed

    var filteredIncidents: [IncidentReport] {
        let calendar = Calendar.current
        let now = Date.now

        switch filterOption {
        case .all:
            return incidents
        case .today:
            return incidents.filter { calendar.isDateInToday($0.occurredAt) }
        case .thisWeek:
            let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
            return incidents.filter { $0.occurredAt >= startOfWeek }
        }
    }

    /// Groups filtered incidents by date for sectioned display.
    var groupedIncidents: [(date: Date, incidents: [IncidentReport])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: filteredIncidents) { incident in
            calendar.startOfDay(for: incident.occurredAt)
        }
        return grouped
            .map { (date: $0.key, incidents: $0.value) }
            .sorted { $0.date > $1.date }
    }

    // MARK: - Actions

    func loadIncidents() async {
        isLoading = true
        defer { isLoading = false }
        do {
            incidents = try incidentService.allIncidents()
        } catch {
            errorMessage = "Could not load incidents. Please try again."
        }
    }
}
