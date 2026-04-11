//
//  IncidentFormView.swift
//  NurseryConnect
//

import SwiftUI
import SwiftData

struct IncidentFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: IncidentFormViewModel
    var onSubmitted: (() -> Void)?

    var body: some View {
        NavigationStack {
            ZStack {
                Form {
                    categorySection
                    severitySection
                    whenWhereSection
                    descriptionSection
                    bodyMapSection
                    actionTakenSection
                    witnessesSection
                    submitSection
                }

                if viewModel.submissionState == .success {
                    IncidentSubmittedView {
                        onSubmitted?()
                    }
                }
            }
            .navigationTitle("Report Incident")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .scrollDismissesKeyboard(.immediately)
            .interactiveDismissDisabled(viewModel.isSubmitting)
        }
    }

    // MARK: - Category

    private var categorySection: some View {
        Section("Category") {
            IncidentCategoryPicker(selected: $viewModel.category)
        }
    }

    // MARK: - Severity

    private var severitySection: some View {
        Section("Severity") {
            Picker("Severity", selection: $viewModel.severity) {
                ForEach(IncidentSeverity.allCases) { level in
                    HStack {
                        Circle()
                            .fill(level.indicatorColor)
                            .frame(width: 10, height: 10)
                        Text(level.displayName)
                    }
                    .tag(level)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    // MARK: - When and Where

    private var whenWhereSection: some View {
        Section("When and Where") {
            // Timestamp is set by system clock and shown read-only for compliance
            LabeledContent("Time") {
                Text(viewModel.occurredAt.absoluteFormatted())
                    .foregroundColor(.appTextSecondary)
            }
            TextField("Location (e.g., outdoor play area)", text: $viewModel.location)
        }
    }

    // MARK: - Description

    private var descriptionSection: some View {
        Section("What Happened") {
            TextEditor(text: $viewModel.descriptionText)
                .frame(minHeight: 100)
                .accessibilityIdentifier("incidentForm.description")
        }
    }

    // MARK: - Body Map

    private var bodyMapSection: some View {
        Section("Injury Location") {
            BodyMapView(selectedLocations: $viewModel.bodyMapLocations)
        }
    }

    // MARK: - Action Taken

    private var actionTakenSection: some View {
        Section("Action Taken") {
            TextEditor(text: $viewModel.immediateActionTaken)
                .frame(minHeight: 80)
                .accessibilityIdentifier("incidentForm.actionTaken")
        }
    }

    // MARK: - Witnesses

    private var witnessesSection: some View {
        Section("Witnesses") {
            TextField("Witness names (optional)", text: $viewModel.witnesses)
        }
    }

    // MARK: - Submit

    private var submitSection: some View {
        Section {
            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.appCaption)
                    .foregroundColor(.appDanger)
            }

            Button {
                Task { await viewModel.submitIncident() }
            } label: {
                HStack {
                    if viewModel.isSubmitting {
                        ProgressView()
                            .tint(.white)
                    }
                    Text("Submit Incident Report")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity, minHeight: AppSpacing.minTapTarget)
            }
            .buttonStyle(.primary)
            .disabled(viewModel.isSubmitting)
            .accessibilityIdentifier("incidentForm.submitButton")
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
        }
    }
}

#Preview {
    let container = try! ModelContainerProvider.makeInMemoryContainer()
    let context = container.mainContext
    let seedService = SeedDataService(context: context)
    try! seedService.seedIfNeeded()
    let children = try! context.fetch(FetchDescriptor<Child>())

    return IncidentFormView(
        viewModel: IncidentFormViewModel(
            child: children.first!,
            incidentService: IncidentService(
                context: context,
                dispatchService: MockDispatchService()
            )
        )
    )
    .modelContainer(container)
}
