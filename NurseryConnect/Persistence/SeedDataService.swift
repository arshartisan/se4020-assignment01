//
//  SeedDataService.swift
//  NurseryConnect
//

import Foundation
import SwiftData

@MainActor
struct SeedDataService {
    let context: ModelContext

    func seedIfNeeded() throws {
        let descriptor = FetchDescriptor<Child>()
        let existing = try context.fetch(descriptor)
        guard existing.isEmpty else { return }

        let keyworker = "Sarah Mitchell"
        let cal = Calendar.current
        let now = Date.now

        func dob(yearsAgo: Int, monthsAgo: Int = 0) -> Date {
            cal.date(byAdding: DateComponents(year: -yearsAgo, month: -monthsAgo), to: now) ?? now
        }

        let roster: [Child] = [
            Child(firstName: "Oliver", lastName: "Bennett", dateOfBirth: dob(yearsAgo: 3),
                  roomName: "Sunshine Room", keyworkerName: keyworker,
                  allergies: ["Peanuts"], dietaryNotes: "Vegetarian",
                  photographyConsent: true),
            Child(firstName: "Amelia", lastName: "Clarke", dateOfBirth: dob(yearsAgo: 2, monthsAgo: 6),
                  roomName: "Sunshine Room", keyworkerName: keyworker,
                  allergies: [], dietaryNotes: nil, photographyConsent: true),
            Child(firstName: "Noah", lastName: "Davies", dateOfBirth: dob(yearsAgo: 4),
                  roomName: "Sunshine Room", keyworkerName: keyworker,
                  allergies: ["Dairy", "Eggs"], dietaryNotes: "Lactose intolerant",
                  photographyConsent: false),
            Child(firstName: "Isla", lastName: "Edwards", dateOfBirth: dob(yearsAgo: 3, monthsAgo: 3),
                  roomName: "Sunshine Room", keyworkerName: keyworker,
                  allergies: [], dietaryNotes: nil, photographyConsent: true),
            Child(firstName: "Leo", lastName: "Foster", dateOfBirth: dob(yearsAgo: 2),
                  roomName: "Sunshine Room", keyworkerName: keyworker,
                  allergies: ["Sesame"], dietaryNotes: "Halal", photographyConsent: true),
            Child(firstName: "Mia", lastName: "Griffiths", dateOfBirth: dob(yearsAgo: 4, monthsAgo: 2),
                  roomName: "Sunshine Room", keyworkerName: keyworker,
                  allergies: [], dietaryNotes: nil, photographyConsent: true)
        ]

        roster.forEach { context.insert($0) }
        try context.save()
    }
}
