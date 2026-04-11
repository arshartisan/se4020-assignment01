//
//  IncidentFormViewModel.swift
//  NurseryConnect
//

import Foundation
import Observation

enum SubmissionState: Equatable {
    case idle
    case submitting
    case success
    case failed(String)
}

@Observable
@MainActor
final class IncidentFormViewModel {
    // MARK: - Form State
    var category: IncidentCategory = .minorAccident
    var severity: IncidentSeverity = .low
    var occurredAt: Date = .now
    var location: String = ""
    var descriptionText: String = ""
    var immediateActionTaken: String = ""
    var witnesses: String = ""
    var bodyMapLocations: [BodyMapLocation] = []

    // MARK: - Submission State
    var submissionState: SubmissionState = .idle
    var errorMessage: String?

    var isSubmitting: Bool { submissionState == .submitting }

    // MARK: - Dependencies
    let child: Child
    private let incidentService: IncidentService

    init(child: Child, incidentService: IncidentService) {
        self.child = child
        self.incidentService = incidentService
    }

    // MARK: - Actions

    func toggleBodyMapLocation(_ location: BodyMapLocation) {
        if let index = bodyMapLocations.firstIndex(of: location) {
            bodyMapLocations.remove(at: index)
        } else {
            bodyMapLocations.append(location)
        }
    }

    func submitIncident() async {
        submissionState = .submitting
        errorMessage = nil

        let incident = IncidentReport(
            child: child,
            category: category,
            severity: severity,
            occurredAt: occurredAt,
            location: location,
            descriptionText: descriptionText,
            immediateActionTaken: immediateActionTaken,
            witnesses: witnesses,
            loggedByKeyworker: "Sarah Mitchell"
        )
        incident.bodyMapLocations = bodyMapLocations

        do {
            try await incidentService.submit(incident)
            Haptics.success()
            submissionState = .success
        } catch {
            Haptics.error()
            errorMessage = error.localizedDescription
            submissionState = .failed(error.localizedDescription)
        }
    }
}
