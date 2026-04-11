//
//  ChildDetailView.swift
//  NurseryConnect
//

import SwiftUI
import SwiftData

struct ChildDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var viewModel: ChildDetailViewModel

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    childHeaderCard
                    QuickActionsBar { type in
                        viewModel.presentDiaryForm(type: type)
                    } onReportIncident: {
                        viewModel.presentIncidentForm()
                    }
                    diaryTimelineContent
                }
                .padding(AppSpacing.md)
            }

            ConfirmationToast(message: viewModel.toastMessage, isShowing: $viewModel.showToast)
        }
        .background(Color.appBackground)
        .navigationTitle(viewModel.child.firstName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: "incidentHistory") {
                    Label("Incident History", systemImage: AppIcons.incident)
                        .foregroundColor(.appDanger)
                }
            }
        }
        .errorAlert($viewModel.errorMessage)
        .fullScreenCover(isPresented: $viewModel.showIncidentForm) {
            viewModel.onIncidentFormDismissed()
        } content: {
            IncidentFormView(
                viewModel: IncidentFormViewModel(
                    child: viewModel.child,
                    incidentService: IncidentService(
                        context: modelContext,
                        dispatchService: MockDispatchService()
                    )
                ),
                onSubmitted: {
                    viewModel.onIncidentSubmitted()
                }
            )
        }
        .sheet(isPresented: $viewModel.showDiaryForm) {
            Task { await viewModel.onDiaryFormDismissed() }
        } content: {
            DiaryEntryFormView(
                viewModel: DiaryEntryFormViewModel(
                    child: viewModel.child,
                    diaryService: DiaryService(context: modelContext),
                    selectedType: viewModel.selectedDiaryType
                ),
                onSaved: {
                    viewModel.onDiaryEntrySaved()
                }
            )
        }
        .task {
            await viewModel.loadEntries()
        }
    }

    // MARK: - Child Header

    private var childHeaderCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack {
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text(viewModel.child.fullName)
                        .font(.appTitle)
                        .foregroundColor(.appTextPrimary)

                    let months = viewModel.child.ageInMonths
                    Text("\(months / 12)y \(months % 12)m \u{00B7} \(viewModel.child.roomName)")
                        .font(.appBody)
                        .foregroundColor(.appTextSecondary)
                }
                Spacer()
                if !viewModel.child.photographyConsent {
                    Image(systemName: "camera.fill")
                        .foregroundColor(.appDanger)
                        .font(.title3)
                        .accessibilityLabel("No photography consent")
                }
            }

            if !viewModel.child.allergies.isEmpty {
                HStack(spacing: AppSpacing.xs) {
                    Image(systemName: AppIcons.warning)
                        .foregroundColor(.appDanger)
                        .font(.caption)
                    Text("Allergies: \(viewModel.child.allergies.joined(separator: ", "))")
                        .font(.appCaption)
                        .foregroundColor(.appDanger)
                        .fontWeight(.semibold)
                }
            }

            if let dietary = viewModel.child.dietaryNotes, !dietary.isEmpty {
                HStack(spacing: AppSpacing.xs) {
                    Image(systemName: AppIcons.meal)
                        .foregroundColor(.appTextSecondary)
                        .font(.caption)
                    Text(dietary)
                        .font(.appCaption)
                        .foregroundColor(.appTextSecondary)
                }
            }
        }
        .cardStyle()
    }

    // MARK: - Timeline Content

    @ViewBuilder
    private var diaryTimelineContent: some View {
        if viewModel.isLoading {
            LoadingView(label: "Loading diary\u{2026}")
                .frame(height: 200)
        } else if viewModel.entries.isEmpty {
            EmptyStateView(
                icon: AppIcons.note,
                title: "No Entries Today",
                subtitle: "Tap a quick action above to log the first entry."
            )
            .frame(height: 200)
        } else {
            DiaryTimelineSection(entries: viewModel.entries)
        }
    }
}

#Preview {
    let container = try! ModelContainerProvider.makeInMemoryContainer()
    let context = container.mainContext
    let seedService = SeedDataService(context: context)
    try! seedService.seedIfNeeded()
    let children = try! context.fetch(FetchDescriptor<Child>())

    return NavigationStack {
        ChildDetailView(
            viewModel: ChildDetailViewModel(
                child: children.first!,
                diaryService: DiaryService(context: context)
            )
        )
    }
    .modelContainer(container)
}
