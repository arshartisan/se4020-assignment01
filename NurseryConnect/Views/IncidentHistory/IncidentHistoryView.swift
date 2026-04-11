//
//  IncidentHistoryView.swift
//  NurseryConnect
//

import SwiftUI
import SwiftData

struct IncidentHistoryView: View {
    @Bindable var viewModel: IncidentHistoryViewModel

    var body: some View {
        VStack(spacing: 0) {
            filterBar
            incidentList
        }
        .background(Color.appBackground)
        .navigationTitle("Incident History")
        .navigationBarTitleDisplayMode(.inline)
        .errorAlert($viewModel.errorMessage)
        .task {
            await viewModel.loadIncidents()
        }
    }

    // MARK: - Filter

    private var filterBar: some View {
        Picker("Filter", selection: $viewModel.filterOption) {
            ForEach(IncidentFilterOption.allCases) { option in
                Text(option.displayName).tag(option)
            }
        }
        .pickerStyle(.segmented)
        .padding(AppSpacing.md)
    }

    // MARK: - List

    @ViewBuilder
    private var incidentList: some View {
        if viewModel.isLoading {
            LoadingView(label: "Loading incidents\u{2026}")
                .frame(maxHeight: .infinity)
        } else if viewModel.filteredIncidents.isEmpty {
            EmptyStateView(
                icon: AppIcons.incident,
                title: "No Incidents",
                subtitle: "No incident reports match the current filter."
            )
            .frame(maxHeight: .infinity)
        } else {
            List {
                ForEach(viewModel.groupedIncidents, id: \.date) { group in
                    Section(group.date.shortDateFormatted()) {
                        ForEach(group.incidents) { incident in
                            NavigationLink(value: incident) {
                                incidentRow(incident)
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
    }

    // MARK: - Row

    private func incidentRow(_ incident: IncidentReport) -> some View {
        HStack(spacing: AppSpacing.sm) {
            // Severity colour bar
            RoundedRectangle(cornerRadius: 2)
                .fill(incident.severity.indicatorColor)
                .frame(width: 4, height: 40)

            // Category icon
            Image(systemName: incident.category.sfSymbol)
                .font(.title3)
                .foregroundColor(.appDanger)
                .frame(width: 30)

            // Content
            VStack(alignment: .leading, spacing: 2) {
                Text(incident.child?.fullName ?? "Unknown Child")
                    .font(.appBody)
                    .fontWeight(.medium)
                    .foregroundColor(.appTextPrimary)
                Text(incident.category.displayName)
                    .font(.appCaption)
                    .foregroundColor(.appTextSecondary)
            }

            Spacer()

            // Time and status
            VStack(alignment: .trailing, spacing: 2) {
                Text(incident.occurredAt.timeFormatted())
                    .font(.appCaption)
                    .foregroundColor(.appTextSecondary)
                dispatchBadge(for: incident.dispatchStatus)
            }
        }
        .padding(.vertical, AppSpacing.xs)
    }

    private func dispatchBadge(for status: String) -> some View {
        Text(status.capitalized)
            .font(.system(size: 10, weight: .semibold))
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .foregroundColor(status == "dispatched" ? .appSuccess : .appWarning)
            .background(
                (status == "dispatched" ? Color.appSuccess : Color.appWarning)
                    .opacity(0.15)
            )
            .clipShape(Capsule())
    }
}

#Preview {
    let container = try! ModelContainerProvider.makeInMemoryContainer()
    let context = container.mainContext

    return NavigationStack {
        IncidentHistoryView(
            viewModel: IncidentHistoryViewModel(
                incidentService: IncidentService(
                    context: context,
                    dispatchService: MockDispatchService()
                )
            )
        )
    }
    .modelContainer(container)
}
