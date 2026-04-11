//
//  ModelContainerProvider.swift
//  NurseryConnect
//
//  SwiftData uses iOS Data Protection class by default; production would set `.complete`.
//

import Foundation
import SwiftData

enum ModelContainerProvider {

    /// Production container — persists to disk.
    static func makeProductionContainer() throws -> ModelContainer {
        let schema = Schema([
            Child.self,
            DiaryEntry.self,
            IncidentReport.self
        ])
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        return try ModelContainer(for: schema, configurations: [configuration])
    }

    /// In-memory container for unit tests and SwiftUI previews.
    static func makeInMemoryContainer() throws -> ModelContainer {
        let schema = Schema([
            Child.self,
            DiaryEntry.self,
            IncidentReport.self
        ])
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: true
        )
        return try ModelContainer(for: schema, configurations: [configuration])
    }
}
