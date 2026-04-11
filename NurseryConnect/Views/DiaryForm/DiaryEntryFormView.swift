//
//  DiaryEntryFormView.swift
//  NurseryConnect
//

import SwiftUI

struct DiaryEntryFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: DiaryEntryFormViewModel
    var onSaved: (() -> Void)?

    var body: some View {
        NavigationStack {
            Form {
                // Entry type picker
                Section {
                    Picker("Type", selection: $viewModel.selectedType) {
                        ForEach(DiaryEntryType.allCases) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                    .padding(.horizontal)
                }

                // Timestamp
                Section {
                    DatePicker("Time", selection: $viewModel.timestamp, displayedComponents: [.date, .hourAndMinute])
                }

                // Type-specific fields
                Section("Details") {
                    typeSpecificFields
                }

                // Notes
                Section("Notes") {
                    TextEditor(text: $viewModel.notes)
                        .frame(minHeight: 80)
                }

                // Validation error
                if let error = viewModel.validationError {
                    Section {
                        Text(error)
                            .font(.appCaption)
                            .foregroundColor(.appDanger)
                    }
                }

                // Save button
                Section {
                    Button {
                        Task { await viewModel.saveEntry() }
                    } label: {
                        HStack {
                            Spacer()
                            if viewModel.isSaving {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Save Entry")
                            }
                            Spacer()
                        }
                    }
                    .buttonStyle(.primary)
                    .disabled(!viewModel.isValid || viewModel.isSaving)
                    .accessibilityIdentifier("diaryForm.saveButton")
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("New \(viewModel.selectedType.displayName)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
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
