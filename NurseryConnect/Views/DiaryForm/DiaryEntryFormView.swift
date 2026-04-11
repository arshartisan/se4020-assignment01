//
//  DiaryEntryFormView.swift
//  NurseryConnect
//

import SwiftUI
import SwiftData

struct DiaryEntryFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: DiaryEntryFormViewModel
    var onSaved: (() -> Void)?

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: AppSpacing.md) {
                        headerCard
                        typePicker
                        timestampCard
                        detailsCard
                        notesCard
                        validationMessage
                        saveButton
                    }
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.bottom, AppSpacing.lg)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.appTextSecondary)
                }
            }
            .errorAlert($viewModel.errorMessage)
            .onChange(of: viewModel.didSave) { _, saved in
                if saved {
                    onSaved?()
                    dismiss()
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    // MARK: - Header Card

    private var headerCard: some View {
        HStack(spacing: AppSpacing.md) {
            ZStack {
                Circle()
                    .fill(Color.appPrimary.opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: "pencil")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.appPrimary)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("New \(viewModel.selectedType.displayName)")
                    .font(.appHeadline)
                    .foregroundColor(.appTextPrimary)
                Text("Daily Diary Entry")
                    .font(.appCaption)
                    .foregroundColor(.appTextSecondary)
            }

            Spacer()

            Button { dismiss() } label: {
                ZStack {
                    Circle()
                        .fill(Color.appBackground)
                        .frame(width: 40, height: 40)
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.appTextSecondary)
                }
            }
            .accessibilityLabel("Close")
        }
        .padding(AppSpacing.md)
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.cardCornerRadius))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }

    // MARK: - Type Picker

    private var typePicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.sm) {
                ForEach(DiaryEntryType.allCases) { type in
                    typeChip(for: type)
                }
            }
            .padding(.horizontal, AppSpacing.xs)
            .padding(.vertical, AppSpacing.xs)
        }
    }

    private func typeChip(for type: DiaryEntryType) -> some View {
        let isSelected = viewModel.selectedType == type
        return Button {
            viewModel.selectedType = type
        } label: {
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: type.sfSymbol)
                    .font(.system(size: 14, weight: .medium))
                Text(type.displayName)
                    .font(.appCaption)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, 10)
            .background(isSelected ? Color.appPrimary : Color.appSurface)
            .foregroundColor(isSelected ? .white : .appTextSecondary)
            .clipShape(Capsule())
            .shadow(color: isSelected ? Color.appPrimary.opacity(0.3) : .black.opacity(0.04),
                    radius: isSelected ? 6 : 4, x: 0, y: 2)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(type.displayName)\(isSelected ? ", selected" : "")")
    }

    // MARK: - Timestamp Card

    private var timestampCard: some View {
        HStack(spacing: AppSpacing.md) {
            ZStack {
                Circle()
                    .fill(Color.appPrimary.opacity(0.1))
                    .frame(width: 40, height: 40)
                Image(systemName: "clock")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.appPrimary)
            }

            DatePicker("Time", selection: $viewModel.timestamp, displayedComponents: [.date, .hourAndMinute])
                .font(.appBody)
                .labelsHidden()
        }
        .padding(AppSpacing.md)
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.cardCornerRadius))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }

    // MARK: - Details Card

    private var detailsCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Label {
                Text("Details")
                    .font(.appCaption)
                    .foregroundColor(.appTextSecondary)
                    .textCase(.uppercase)
            } icon: {
                Image(systemName: viewModel.selectedType.sfSymbol)
                    .font(.system(size: 12))
                    .foregroundColor(.appTextSecondary)
            }
            .padding(.horizontal, AppSpacing.xs)

            VStack(spacing: 1) {
                typeSpecificFields
            }
            .id(viewModel.selectedType)
            .padding(AppSpacing.md)
            .background(Color.appSurface)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.cardCornerRadius))
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
    }

    // MARK: - Notes Card

    private var notesCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Label {
                Text("Notes")
                    .font(.appCaption)
                    .foregroundColor(.appTextSecondary)
                    .textCase(.uppercase)
            } icon: {
                Image(systemName: "text.alignleft")
                    .font(.system(size: 12))
                    .foregroundColor(.appTextSecondary)
            }
            .padding(.horizontal, AppSpacing.xs)

            TextEditor(text: $viewModel.notes)
                .font(.appBody)
                .frame(minHeight: 80)
                .padding(AppSpacing.sm)
                .scrollContentBackground(.hidden)
                .background(Color.appSurface)
                .clipShape(RoundedRectangle(cornerRadius: AppSpacing.cardCornerRadius))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
    }

    // MARK: - Validation

    @ViewBuilder
    private var validationMessage: some View {
        if let error = viewModel.validationError {
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.appDanger)
                    .font(.system(size: 14))
                Text(error)
                    .font(.appCaption)
                    .foregroundColor(.appDanger)
            }
            .padding(AppSpacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.appDanger.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.cornerRadius))
        }
    }

    // MARK: - Save Button

    private var saveButton: some View {
        Button {
            Task { await viewModel.saveEntry() }
        } label: {
            HStack(spacing: AppSpacing.sm) {
                if viewModel.isSaving {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Save Entry")
                        .font(.appHeadline)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, minHeight: 54)
            .background(
                viewModel.isValid && !viewModel.isSaving
                    ? Color.appPrimary
                    : Color.appPrimary.opacity(0.4)
            )
            .clipShape(Capsule())
            .shadow(color: Color.appPrimary.opacity(0.3), radius: 10, x: 0, y: 4)
        }
        .disabled(!viewModel.isValid || viewModel.isSaving)
        .accessibilityIdentifier("diaryForm.saveButton")
        .padding(.top, AppSpacing.sm)
    }

    // MARK: - Type-Specific Fields

    @ViewBuilder
    private var typeSpecificFields: some View {
        switch viewModel.selectedType {
        case .activity:
            ActivityFormFields(
                activityName: $viewModel.activityName,
                durationMinutes: $viewModel.activityDurationMinutes
            )
        case .meal:
            MealFormFields(
                mealType: $viewModel.mealType,
                portionConsumed: $viewModel.portionConsumed
            )
        case .nap:
            NapFormFields(
                startTime: $viewModel.napStartTime,
                endTime: $viewModel.napEndTime
            )
        case .nappy:
            NappyFormFields(nappyType: $viewModel.nappyType)
        case .wellbeing:
            WellbeingFormFields(moodRating: $viewModel.moodRating)
        }
    }
}
