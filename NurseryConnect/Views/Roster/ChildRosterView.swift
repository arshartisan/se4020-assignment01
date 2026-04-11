//
//  ChildRosterView.swift
//  NurseryConnect
//
//  Roster is filtered by keyworker name — Article 5 data minimisation.
//

import SwiftUI

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
                        ForEach(viewModel.children) { child in
                            NavigationLink(value: child) {
                                ChildRosterCard(child: child)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(AppSpacing.md)
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
