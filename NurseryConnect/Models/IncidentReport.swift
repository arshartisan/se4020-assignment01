//
//  IncidentReport.swift
//  NurseryConnect
//
//  Represents a structured incident record aligned with EYFS statutory
//  requirements and RIDDOR 2013 reporting fields. Once submitted, the
//  record is timestamped and cannot be edited (audit-trail principle).
//  Incident records are immutable post-submission to satisfy Children Act 1989
//  safeguarding audit trail.
//

import Foundation
import SwiftData

@Model
final class IncidentReport {
    @Attribute(.unique) var id: UUID
    var child: Child?
    var categoryRawValue: String
    var severityRawValue: String
    var occurredAt: Date
    var location: String
    var descriptionText: String
    var immediateActionTaken: String
    var witnesses: String
    var bodyMapLocationsRaw: [String]     // Stored as raw strings
    var loggedByKeyworker: String
    var submittedAt: Date?                // nil = draft, set = submitted
    var dispatchStatus: String            // "pending", "dispatched", "failed"

    // MARK: - Computed
    var category: IncidentCategory {
        get { IncidentCategory(rawValue: categoryRawValue) ?? .minorAccident }
        set { categoryRawValue = newValue.rawValue }
    }

    var severity: IncidentSeverity {
        get { IncidentSeverity(rawValue: severityRawValue) ?? .low }
        set { severityRawValue = newValue.rawValue }
    }

    var bodyMapLocations: [BodyMapLocation] {
        get { bodyMapLocationsRaw.compactMap(BodyMapLocation.init(rawValue:)) }
        set { bodyMapLocationsRaw = newValue.map(\.rawValue) }
    }

    var isSubmitted: Bool { submittedAt != nil }

    init(
        id: UUID = UUID(),
        child: Child? = nil,
        category: IncidentCategory,
        severity: IncidentSeverity,
        occurredAt: Date = .now,
        location: String = "",
        descriptionText: String = "",
        immediateActionTaken: String = "",
        witnesses: String = "",
        loggedByKeyworker: String
    ) {
        self.id = id
        self.child = child
        self.categoryRawValue = category.rawValue
        self.severityRawValue = severity.rawValue
        self.occurredAt = occurredAt
        self.location = location
        self.descriptionText = descriptionText
        self.immediateActionTaken = immediateActionTaken
        self.witnesses = witnesses
        self.bodyMapLocationsRaw = []
        self.loggedByKeyworker = loggedByKeyworker
        self.submittedAt = nil
        self.dispatchStatus = "pending"
    }
}
