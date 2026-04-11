//
//  IncidentReportTests.swift
//  NurseryConnectTests
//

import Testing
import Foundation
import SwiftData
@testable import NurseryConnect

@MainActor
struct IncidentReportTests {

    private func makeChild() -> Child {
        Child(
            firstName: "Test",
            lastName: "Child",
            dateOfBirth: .now,
            roomName: "Test Room",
            keyworkerName: "Test Keyworker"
        )
    }

    @Test
    func initSetsDefaultValues() {
        let incident = IncidentReport(
            child: makeChild(),
            category: .minorAccident,
            severity: .low,
            loggedByKeyworker: "Sarah"
        )

        #expect(incident.location == "")
        #expect(incident.descriptionText == "")
        #expect(incident.immediateActionTaken == "")
        #expect(incident.witnesses == "")
        #expect(incident.bodyMapLocationsRaw.isEmpty)
        #expect(incident.submittedAt == nil)
        #expect(incident.dispatchStatus == "pending")
    }

    @Test
    func isSubmittedReturnsFalseWhenSubmittedAtIsNil() {
        let incident = IncidentReport(
            child: makeChild(),
            category: .minorAccident,
            severity: .low,
            loggedByKeyworker: "Sarah"
        )

        #expect(incident.isSubmitted == false)
    }

    @Test
    func isSubmittedReturnsTrueWhenSubmittedAtIsSet() {
        let incident = IncidentReport(
            child: makeChild(),
            category: .minorAccident,
            severity: .low,
            loggedByKeyworker: "Sarah"
        )
        incident.submittedAt = .now

        #expect(incident.isSubmitted == true)
    }

    @Test
    func bodyMapLocationsComputedPropertyRoundTrips() {
        let incident = IncidentReport(
            child: makeChild(),
            category: .firstAidRequired,
            severity: .medium,
            loggedByKeyworker: "Sarah"
        )

        #expect(incident.bodyMapLocations.isEmpty)

        incident.bodyMapLocations = [.head, .leftArm, .torso]
        #expect(incident.bodyMapLocationsRaw == ["head", "leftArm", "torso"])
        #expect(incident.bodyMapLocations == [.head, .leftArm, .torso])
    }

    @Test
    func categoryAndSeverityComputedPropertiesRoundTrip() {
        let incident = IncidentReport(
            child: makeChild(),
            category: .minorAccident,
            severity: .low,
            loggedByKeyworker: "Sarah"
        )

        #expect(incident.category == .minorAccident)
        #expect(incident.severity == .low)

        incident.category = .safeguardingConcern
        incident.severity = .high

        #expect(incident.categoryRawValue == "safeguardingConcern")
        #expect(incident.severityRawValue == "high")
        #expect(incident.category == .safeguardingConcern)
        #expect(incident.severity == .high)
    }
}
