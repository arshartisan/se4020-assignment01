//
//  Child.swift
//  NurseryConnect
//
//  Represents a child on the keyworker's assigned roster.
//  Roster scope is enforced by `keyworkerName` — UK GDPR Article 5 (data minimisation).
//  In production, this would be populated from a backend with strict
//  row-level access control (UK GDPR Article 5 — data minimisation).
//  In this MVP, the roster is seeded locally with fictional data.
//

import Foundation
import SwiftData

@Model
final class Child {
    // MARK: - Stored Properties
    @Attribute(.unique) var id: UUID
    var firstName: String
    var lastName: String
    var dateOfBirth: Date
    var roomName: String                  // e.g. "Sunshine Room"
    var keyworkerName: String             // The logged-in keyworker (the user)
    var allergies: [String]               // Plain strings for MVP simplicity
    var dietaryNotes: String?
    var photographyConsent: Bool          // Compliance flag — UI must respect this
    var createdAt: Date

    // MARK: - Relationships
    @Relationship(deleteRule: .cascade, inverse: \DiaryEntry.child)
    var diaryEntries: [DiaryEntry] = []

    @Relationship(deleteRule: .cascade, inverse: \IncidentReport.child)
    var incidents: [IncidentReport] = []

    // MARK: - Computed
    var fullName: String { "\(firstName) \(lastName)" }
    var ageInMonths: Int {
        Calendar.current.dateComponents([.month], from: dateOfBirth, to: .now).month ?? 0
    }

    // MARK: - Init
    init(
        id: UUID = UUID(),
        firstName: String,
        lastName: String,
        dateOfBirth: Date,
        roomName: String,
        keyworkerName: String,
        allergies: [String] = [],
        dietaryNotes: String? = nil,
        photographyConsent: Bool = true,
        createdAt: Date = .now
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.roomName = roomName
        self.keyworkerName = keyworkerName
        self.allergies = allergies
        self.dietaryNotes = dietaryNotes
        self.photographyConsent = photographyConsent
        self.createdAt = createdAt
    }
}
