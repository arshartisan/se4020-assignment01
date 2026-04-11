//
//  IncidentServiceTests.swift
//  NurseryConnectTests
//

import Testing
import Foundation
import SwiftData
@testable import NurseryConnect

@MainActor
struct IncidentServiceTests {

    private func makeSUT() throws -> (IncidentService, ModelContext, Child) {
        let container = try ModelContainerProvider.makeInMemoryContainer()
        let context = ModelContext(container)
        let child = Child(
            firstName: "Test",
            lastName: "Child",
            dateOfBirth: .now,
            roomName: "Test Room",
            keyworkerName: "Test Keyworker"
        )
        context.insert(child)
        let service = IncidentService(
            context: context,
            dispatchService: MockDispatchService()
        )
        return (service, context, child)
    }

    private func makeValidIncident(child: Child) -> IncidentReport {
        let incident = IncidentReport(
            child: child,
            category: .minorAccident,
            severity: .low,
            location: "Playground",
            descriptionText: "Child fell off the slide",
            immediateActionTaken: "Applied cold compress",
            loggedByKeyworker: "Sarah"
        )
        return incident
    }

    @Test
    func submitsValidIncident() async throws {
        let (sut, _, child) = try makeSUT()
        let incident = makeValidIncident(child: child)

        try await sut.submit(incident)

        let all = try sut.allIncidents()
        #expect(all.count == 1)
        #expect(all.first?.descriptionText == "Child fell off the slide")
    }

    @Test
    func rejectsIncidentWithEmptyDescription() async throws {
        let (sut, _, child) = try makeSUT()
        let incident = IncidentReport(
            child: child,
            category: .minorAccident,
            severity: .low,
            descriptionText: "",
            immediateActionTaken: "Applied compress",
            loggedByKeyworker: "Sarah"
        )

        await #expect(throws: IncidentServiceError.self) {
            try await sut.submit(incident)
        }
    }

    @Test
    func rejectsIncidentWithEmptyActionTaken() async throws {
        let (sut, _, child) = try makeSUT()
        let incident = IncidentReport(
            child: child,
            category: .minorAccident,
            severity: .low,
            descriptionText: "Something happened",
            immediateActionTaken: "   ",
            loggedByKeyworker: "Sarah"
        )

        await #expect(throws: IncidentServiceError.self) {
            try await sut.submit(incident)
        }
    }

    @Test
    func setsSubmittedAtOnSuccessfulSubmission() async throws {
        let (sut, _, child) = try makeSUT()
        let incident = makeValidIncident(child: child)

        #expect(incident.submittedAt == nil)

        try await sut.submit(incident)

        #expect(incident.submittedAt != nil)
    }

    @Test
    func setsDispatchStatusToDispatchedAfterCompletion() async throws {
        let (sut, _, child) = try makeSUT()
        let incident = makeValidIncident(child: child)

        #expect(incident.dispatchStatus == "pending")

        try await sut.submit(incident)

        #expect(incident.dispatchStatus == "dispatched")
    }
}
