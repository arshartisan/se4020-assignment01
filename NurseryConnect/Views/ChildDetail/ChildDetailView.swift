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
            Color.appBackground.ignoresSafeArea()

            ScrollView {
                VStack(spacing: AppSpacing.md) {
                    profileHeader
                    infoChips
                    quickActionsSection
                    diaryTimelineContent
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.bottom, AppSpacing.lg)
            }

            ConfirmationToast(message: viewModel.toastMessage, isShowing: $viewModel.showToast)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(viewModel.child.firstName)
                    .font(.appHeadline)
            }
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

    // MARK: - Profile Header

    private var profileHeader: some View {
        HStack(spacing: AppSpacing.md) {
            // Avatar
            ZStack {
                Circle()
                    .fill(avatarColor.opacity(0.3))
                    .frame(width: 56, height: 56)
                Text(String(viewModel.child.firstName.prefix(1)))
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .foregroundColor(avatarColor)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.child.fullName)
                    .font(.appTitle)
                    .foregroundColor(.appTextPrimary)

                let months = viewModel.child.ageInMonths
                Text("\(months / 12)y \(months % 12)m \u{00B7} \(viewModel.child.roomName)")
                    .font(.appCaption)
                    .foregroundColor(.appTextSecondary)
            }

            Spacer()

            if !viewModel.child.photographyConsent {
                ZStack {
                    Circle()
                        .fill(Color.appDanger.opacity(0.1))
                        .frame(width: 36, height: 36)
                    Image(systemName: "camera.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.appDanger)
                }
                .accessibilityLabel("No photography consent")
            }
        }
        .padding(AppSpacing.md)
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.cardCornerRadius))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }

    // MARK: - Info Chips

    @ViewBuilder
    private var infoChips: some View {
        if !viewModel.child.allergies.isEmpty || viewModel.child.dietaryNotes != nil {
            HStack(spacing: AppSpacing.sm) {
                if !viewModel.child.allergies.isEmpty {
                    infoChip(
                        icon: AppIcons.warning,
                        text: viewModel.child.allergies.joined(separator: ", "),
                        bgColor: Color.appDanger.opacity(0.12),
                        fgColor: .appDanger
                    )
                }

                if let dietary = viewModel.child.dietaryNotes, !dietary.isEmpty {
                    infoChip(
                        icon: AppIcons.meal,
                        text: dietary,
                        bgColor: Color.appWarning.opacity(0.2),
                        fgColor: .black.opacity(0.6)
                    )
                }
            }
        }
    }

    private func infoChip(icon: String, text: String, bgColor: Color, fgColor: Color) -> some View {
        HStack(spacing: AppSpacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .semibold))
                .accessibilityHidden(true)
            Text(text)
                .font(.caption2)
                .fontWeight(.medium)
                .lineLimit(1)
        }
        .foregroundColor(fgColor)
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background(bgColor)
        .clipShape(Capsule())
    }

    // MARK: - Quick Actions

    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Quick Actions")
                .font(.appHeadline)
                .foregroundColor(.appTextPrimary)
                .padding(.horizontal, AppSpacing.xs)

            QuickActionsBar { type in
                viewModel.presentDiaryForm(type: type)
            } onReportIncident: {
                viewModel.presentIncidentForm()
            }
        }
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

    // MARK: - Helpers

    private var avatarColor: Color {
        let colors: [Color] = [
            Color(red: 0.40, green: 0.65, blue: 0.85),
            Color(red: 0.55, green: 0.78, blue: 0.50),
            Color(red: 0.85, green: 0.55, blue: 0.40),
            Color(red: 0.70, green: 0.50, blue: 0.80),
            Color(red: 0.85, green: 0.45, blue: 0.55),
        ]
        let index = abs(viewModel.child.firstName.hashValue) % colors.count
        return colors[index]
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
