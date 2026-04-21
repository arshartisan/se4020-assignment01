//
//  RootView.swift
//  NurseryConnect
//

import SwiftUI
import SwiftData

struct RootView: View {
    @Environment(\.modelContext) private var modelContext

    @Query private var allIncidents: [IncidentReport]

    var body: some View {
        TabView {
            homeTab
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            incidentsTab
                .tabItem {
                    Label("Incidents", systemImage: AppIcons.incident)
                }
                .badge(allIncidents.count)
        }
        .tint(.appPrimary)
    }

    private var homeTab: some View {
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
        }
    }

    private var incidentsTab: some View {
        NavigationStack {
            IncidentHistoryView(
                viewModel: IncidentHistoryViewModel(
                    incidentService: IncidentService(
                        context: modelContext,
                        dispatchService: MockDispatchService()
                    )
                )
            )
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
