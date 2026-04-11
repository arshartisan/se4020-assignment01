//
//  ChildRosterService.swift
//  NurseryConnect
//
//  Filter by keyworker enforces purpose limitation — keyworkers cannot see other children.
//  Roster is filtered by keyworker name — Article 5 data minimisation.
//

import Foundation
import SwiftData

@MainActor
struct ChildRosterService {
    let context: ModelContext

    func fetchAssignedChildren(for keyworkerName: String) throws -> [Child] {
        let descriptor = FetchDescriptor<Child>(
            predicate: #Predicate { $0.keyworkerName == keyworkerName },
            sortBy: [SortDescriptor(\.firstName)]
        )
        return try context.fetch(descriptor)
    }
}
