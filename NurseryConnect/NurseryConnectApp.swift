//
//  NurseryConnectApp.swift
//  NurseryConnect
//

import SwiftUI
import SwiftData

@main
struct NurseryConnectApp: App {
    var sharedModelContainer: ModelContainer = {
        do {
            return try ModelContainerProvider.makeProductionContainer()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
                .task {
                    let context = sharedModelContainer.mainContext
                    let seedService = SeedDataService(context: context)
                    do {
                        try seedService.seedIfNeeded()
                    } catch {
                        print("Seed data error: \(error)")
                    }
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
