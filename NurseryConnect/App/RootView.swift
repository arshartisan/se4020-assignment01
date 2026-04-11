//
//  RootView.swift
//  NurseryConnect
//

import SwiftUI
import SwiftData

struct RootView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            ChildRosterView(
                viewModel: ChildRosterViewModel(
                    rosterService: ChildRosterService(context: modelContext)
                )
            )
        }
    }
}

#Preview {
    let container = try! ModelContainerProvider.makeInMemoryContainer()
    let context = container.mainContext
    let seedService = SeedDataService(context: context)
    try! seedService.seedIfNeeded()

    return RootView()
        .modelContainer(container)
}
