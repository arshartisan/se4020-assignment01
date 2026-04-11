//
//  IncidentFormViewModelTests.swift
//  NurseryConnectTests
//

import Testing
import Foundation
import SwiftData
@testable import NurseryConnect

@MainActor
struct IncidentFormViewModelTests {

    private func makeSUT() throws -> (IncidentFormViewModel, IncidentService, Child) {
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
        let vm = IncidentFormViewModel(child: child, incidentService: service)
        return (vm, service, child)
    }

    @Test
    func submissionFlowUpdatesStateThroughStages() async throws {
        let (vm, _, _) = try makeSUT()

        #expect(vm.submissionState == .idle)

        vm.descriptionText = "Child bumped head on table"
        vm.immediateActionTaken = "Applied cold compress and monitored"
        vm.location = "Classroom"

        await vm.submitIncident()

        #expect(vm.submissionState == .success)
        #expect(vm.errorMessage == nil)
    }

    @Test
    func errorPathSetsErrorMessage() async throws {
        let (vm, _, _) = try makeSUT()

        // Leave required fields empty to trigger validation error
        vm.descriptionText = ""
        vm.immediateActionTaken = ""

        await vm.submitIncident()

        #expect(vm.submissionState == .failed(vm.errorMessage ?? ""))
        #expect(vm.errorMessage != nil)
    }

    @Test
    func toggleBodyMapLocationAddsAndRemoves() throws {
        let (vm, _, _) = try makeSUT()

        #expect(vm.bodyMapLocations.isEmpty)

        vm.toggleBodyMapLocation(.head)
        #expect(vm.bodyMapLocations == [.head])

        vm.toggleBodyMapLocation(.leftArm)
        #expect(vm.bodyMapLocations == [.head, .leftArm])

        vm.toggleBodyMapLocation(.head)
        #expect(vm.bodyMapLocations == [.leftArm])
    }
}
