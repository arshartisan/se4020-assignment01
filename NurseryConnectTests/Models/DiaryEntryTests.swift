//
//  DiaryEntryTests.swift
//  NurseryConnectTests
//

import Testing
import Foundation
import SwiftData
@testable import NurseryConnect

@MainActor
struct DiaryEntryTests {

    private func makeChild() throws -> Child {
        Child(
            firstName: "Test",
            lastName: "Child",
            dateOfBirth: .now,
            roomName: "Test Room",
            keyworkerName: "Test Keyworker"
        )
    }

    @Test
    func initSetsDefaultValues() throws {
        let child = try makeChild()
        let entry = DiaryEntry(child: child, type: .activity, loggedByKeyworker: "Sarah")

        #expect(entry.notes == "")
        #expect(entry.activityName == nil)
        #expect(entry.mealType == nil)
        #expect(entry.napStartTime == nil)
        #expect(entry.napEndTime == nil)
        #expect(entry.nappyType == nil)
        #expect(entry.moodRatingRawValue == nil)
    }

    @Test
    func typeComputedPropertyRoundTrips() throws {
        let child = try makeChild()
        let entry = DiaryEntry(child: child, type: .activity, loggedByKeyworker: "Sarah")

        #expect(entry.type == .activity)
        #expect(entry.typeRawValue == "activity")

        entry.type = .meal
        #expect(entry.typeRawValue == "meal")
        #expect(entry.type == .meal)

        entry.type = .nap
        #expect(entry.type == .nap)
    }

    @Test
    func moodRatingComputedPropertyRoundTrips() throws {
        let child = try makeChild()
        let entry = DiaryEntry(child: child, type: .wellbeing, loggedByKeyworker: "Sarah")

        #expect(entry.moodRating == nil)

        entry.moodRating = .happy
        #expect(entry.moodRatingRawValue == "happy")
        #expect(entry.moodRating == .happy)

        entry.moodRating = .unsettled
        #expect(entry.moodRating == .unsettled)

        entry.moodRating = nil
        #expect(entry.moodRatingRawValue == nil)
    }

    @Test
    func childRelationshipIsSet() throws {
        let child = try makeChild()
        let entry = DiaryEntry(child: child, type: .activity, loggedByKeyworker: "Sarah")

        #expect(entry.child?.firstName == "Test")
        #expect(entry.loggedByKeyworker == "Sarah")
    }

    @Test
    func allEntryTypesCanBeCreated() throws {
        let child = try makeChild()

        for type in DiaryEntryType.allCases {
            let entry = DiaryEntry(child: child, type: type, loggedByKeyworker: "Sarah")
            #expect(entry.type == type)
        }
    }
}
