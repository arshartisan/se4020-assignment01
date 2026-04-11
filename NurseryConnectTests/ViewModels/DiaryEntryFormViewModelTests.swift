//
//  DiaryEntryFormViewModelTests.swift
//  NurseryConnectTests
//

import Testing
import Foundation
import SwiftData
@testable import NurseryConnect

@MainActor
struct DiaryEntryFormViewModelTests {

    private func makeSUT(type: DiaryEntryType = .activity) throws -> (DiaryEntryFormViewModel, DiaryService, Child) {
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
        let service = DiaryService(context: context)
        let vm = DiaryEntryFormViewModel(
            child: child,
            diaryService: service,
            selectedType: type
        )
        return (vm, service, child)
    }

    @Test
    func activityFormStartsInvalid() throws {
        let (vm, _, _) = try makeSUT(type: .activity)
        #expect(vm.isValid == false)
    }

    @Test
    func activityFormBecomesValidWhenNameFilled() throws {
        let (vm, _, _) = try makeSUT(type: .activity)

        #expect(vm.isValid == false)

        vm.activityName = "Story time"
        #expect(vm.isValid == true)
    }

    @Test
    func mealFormBecomesValidWhenMealTypeSet() throws {
        let (vm, _, _) = try makeSUT(type: .meal)

        #expect(vm.isValid == false)

        vm.mealType = "lunch"
        #expect(vm.isValid == true)
    }

    @Test
    func validationErrorAppearsForMissingRequiredFields() async throws {
        let (vm, _, _) = try makeSUT(type: .activity)

        #expect(vm.validationError == nil)

        await vm.saveEntry()

        #expect(vm.validationError != nil)
        #expect(vm.didSave == false)
    }

    @Test
    func saveTriggersServiceCallAndSetsDidSave() async throws {
        let (vm, service, child) = try makeSUT(type: .activity)

        vm.activityName = "Painting"
        vm.notes = "Used watercolors"

        await vm.saveEntry()

        #expect(vm.didSave == true)

        let entries = try service.entries(for: child)
        #expect(entries.count == 1)
        #expect(entries.first?.activityName == "Painting")
    }
}
