//
//  ChildRosterView.swift
//  NurseryConnect
//
//  Roster is filtered by keyworker name — Article 5 data minimisation.
//

import SwiftUI
import SwiftData

struct ChildRosterView: View {
    @Bindable var viewModel: ChildRosterViewModel

    private let columns = [
        GridItem(.flexible(), spacing: AppSpacing.md),
        GridItem(.flexible(), spacing: AppSpacing.md)
    ]

    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView(label: "Loading children\u{2026}")
            } else if viewModel.children.isEmpty {
                EmptyStateView(
                    icon: AppIcons.roster,
                    title: "No Children Assigned",
                    subtitle: "Your roster is empty. Contact your manager if this seems wrong."
                )
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: AppSpacing.md) {
                        ForEach(Array(viewModel.children.enumerated()), id: \.element.id) { index, child in
                            NavigationLink(value: child) {
                                ChildRosterCard(child: child)
                            }
                            .buttonStyle(.plain)
                            .accessibilityIdentifier("childRoster.card.\(index)")
                        }
                    }
                    .padding(AppSpacing.md)
                    .accessibilityIdentifier("childRoster.grid")
                }
            }
        }
        .navigationTitle("My Children")
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 2) {
                    Text("My Children")
                        .font(.appHeadline)
                    Text("Sarah Mitchell \u{00B7} Sunshine Room")
                        .font(.appCaption)
                        .foregroundColor(.appTextSecondary)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .errorAlert($viewModel.errorMessage)
        .task {
            await viewModel.loadRoster()
        }
    }
}

#Preview {
    let container = try! ModelContainerProvider.makeInMemoryContainer()
    let context = container.mainContext
    let seedService = SeedDataService(context: context)
    try! seedService.seedIfNeeded()

    return NavigationStack {
        ChildRosterView(
            viewModel: ChildRosterViewModel(
                rosterService: ChildRosterService(context: context)
            )
        )
    }
    .modelContainer(container)
}
