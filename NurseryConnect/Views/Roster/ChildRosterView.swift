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
                    VStack(spacing: AppSpacing.md) {
                        greetingHeader
                        statsRow
                        summaryBanner
                        childrenSectionHeader
                        childrenGrid
                    }
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.bottom, AppSpacing.lg)
                }
            }
        }
        .background(Color.appBackground)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Sunshine Room")
                    .font(.appHeadline)
            }
        }
        .errorAlert($viewModel.errorMessage)
        .task {
            await viewModel.loadRoster()
        }
    }

    // MARK: - Greeting Header

    private var greetingHeader: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("My Roster")
                .font(.appCaption)
                .foregroundColor(.appPrimary)
                .textCase(.uppercase)
                .tracking(1.2)

            (Text("Hello Sarah,\nyou have ")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .foregroundColor(.appTextPrimary)
            + Text("\(viewModel.children.count) children")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .foregroundColor(.appTextPrimary)
            + Text(" assigned today")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .foregroundColor(.appTextSecondary))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppSpacing.lg)
        .padding(.top, AppSpacing.sm)
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.cardCornerRadius))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }

    // MARK: - Stats Row

    private var statsRow: some View {
        HStack(spacing: AppSpacing.sm) {
            statChip(
                icon: "heart.fill",
                label: "Wellbeing",
                value: "\(viewModel.children.count) logged",
                color: .appSuccess
            )
            statChip(
                icon: "exclamationmark.triangle.fill",
                label: "Allergies",
                value: "\(childrenWithAllergies) flagged",
                color: .appDanger
            )
            statChip(
                icon: "camera.fill",
                label: "Photo",
                value: "\(childrenWithConsent) consent",
                color: .appPrimary
            )
        }
    }

    private func statChip(icon: String, label: String, value: String, color: Color) -> some View {
        VStack(spacing: AppSpacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(color)
            Text(value)
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.appTextPrimary)
            Text(label)
                .font(.caption2)
                .foregroundColor(.appTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.md)
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.cornerRadius))
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }

    // MARK: - Summary Banner

    private var summaryBanner: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: AppIcons.roster)
                .font(.system(size: 14, weight: .semibold))
            Text("Roster updated for ")
                .font(.appCaption)
            + Text(todayFormatted)
                .font(.appCaption)
                .bold()
        }
        .foregroundColor(.black.opacity(0.7))
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppSpacing.md)
        .background(Color.appWarning.opacity(0.35))
        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.cornerRadius))
    }

    // MARK: - Children Section

    private var childrenSectionHeader: some View {
        HStack {
            Text("Children")
                .font(.appHeadline)
                .foregroundColor(.appTextPrimary)
            Spacer()
            Text("\(viewModel.children.count) total")
                .font(.appCaption)
                .foregroundColor(.appTextSecondary)
        }
        .padding(.top, AppSpacing.xs)
    }

    private var childrenGrid: some View {
        LazyVGrid(columns: columns, spacing: AppSpacing.md) {
            ForEach(Array(viewModel.children.enumerated()), id: \.element.id) { index, child in
                NavigationLink(value: child) {
                    ChildRosterCard(child: child)
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("childRoster.card.\(index)")
            }
        }
        .accessibilityIdentifier("childRoster.grid")
    }

    // MARK: - Helpers

    private var childrenWithAllergies: Int {
        viewModel.children.filter { !$0.allergies.isEmpty }.count
    }

    private var childrenWithConsent: Int {
        viewModel.children.filter { $0.photographyConsent }.count
    }

    private var todayFormatted: String {
        Date.now.formatted(.dateTime.weekday(.wide).month(.wide).day())
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
