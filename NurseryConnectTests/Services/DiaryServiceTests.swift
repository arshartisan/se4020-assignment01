//
//  DiaryServiceTests.swift
//  NurseryConnectTests
//

import Testing
import Foundation
import SwiftData
@testable import NurseryConnect

@MainActor
struct DiaryServiceTests {

    private func makeSUT() throws -> (DiaryService, ModelContext, Child) {
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
        return (DiaryService(context: context), context, child)
    }

    @Test
    func savesValidActivityEntry() async throws {
        let (sut, _, child) = try makeSUT()
        let entry = DiaryEntry(child: child, type: .activity, loggedByKeyworker: "Test")
        entry.activityName = "Story time"
        entry.notes = "Enjoyed the dinosaur book."

        try await sut.save(entry)

        let fetched = try sut.entries(for: child)
        #expect(fetched.count == 1)
        #expect(fetched.first?.activityName == "Story time")
    }

    @Test
    func rejectsActivityEntryWithNoNameOrNotes() async throws {
        let (sut, _, child) = try makeSUT()
        let entry = DiaryEntry(child: child, type: .activity, loggedByKeyworker: "Test")

        await #expect(throws: DiaryServiceError.self) {
            try await sut.save(entry)
        }
    }

    @Test
    func rejectsMealEntryWithoutMealType() async throws {
        let (sut, _, child) = try makeSUT()
        let entry = DiaryEntry(child: child, type: .meal, loggedByKeyworker: "Test")

        await #expect(throws: DiaryServiceError.self) {
            try await sut.save(entry)
        }
    }

    @Test
    func rejectsNapEntryWhereEndBeforeStart() async throws {
        let (sut, _, child) = try makeSUT()
        let entry = DiaryEntry(child: child, type: .nap, loggedByKeyworker: "Test")
        let now = Date.now
        entry.napStartTime = now
        entry.napEndTime = now.addingTimeInterval(-3600)

        await #expect(throws: DiaryServiceError.self) {
            try await sut.save(entry)
        }
    }

    @Test
    func fetchesEntriesSortedNewestFirst() async throws {
        let (sut, _, child) = try makeSUT()

        let older = DiaryEntry(
            child: child,
            type: .activity,
            timestamp: Date.now.addingTimeInterval(-3600),
            loggedByKeyworker: "Test"
        )
        older.activityName = "Painting"

        let newer = DiaryEntry(
            child: child,
            type: .activity,
            timestamp: Date.now,
            loggedByKeyworker: "Test"
        )
        newer.activityName = "Reading"

        try await sut.save(older)
        try await sut.save(newer)

        let fetched = try sut.entries(for: child)
        #expect(fetched.count == 2)
        #expect(fetched.first?.activityName == "Reading")
    }

    @Test
    func fetchesOnlyEntriesForSpecifiedChild() async throws {
        let (sut, context, child1) = try makeSUT()

        let child2 = Child(
            firstName: "Other",
            lastName: "Child",
            dateOfBirth: .now,
            roomName: "Other Room",
            keyworkerName: "Test Keyworker"
        )
        context.insert(child2)

        let entry1 = DiaryEntry(child: child1, type: .activity, loggedByKeyworker: "Test")
        entry1.activityName = "For child 1"
        let entry2 = DiaryEntry(child: child2, type: .activity, loggedByKeyworker: "Test")
        entry2.activityName = "For child 2"

        try await sut.save(entry1)
        try await sut.save(entry2)

        let fetched = try sut.entries(for: child1)
        #expect(fetched.count == 1)
        #expect(fetched.first?.activityName == "For child 1")
    }
}
