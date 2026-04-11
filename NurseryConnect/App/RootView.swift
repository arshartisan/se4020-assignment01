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
            .navigationDestination(for: Child.self) { child in
                ChildDetailView(
                    viewModel: ChildDetailViewModel(
                        child: child,
                        diaryService: DiaryService(context: modelContext)
                    )
                )
            }
            .navigationDestination(for: String.self) { route in
                if route == "incidentHistory" {
                    IncidentHistoryView(
                        viewModel: IncidentHistoryViewModel(
                            incidentService: IncidentService(
                                context: modelContext,
                                dispatchService: MockDispatchService()
                            )
                        )
                    )
                }
            }
            .navigationDestination(for: IncidentReport.self) { incident in
                IncidentDetailView(incident: incident)
            }
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
