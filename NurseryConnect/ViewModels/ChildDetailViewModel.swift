//
//  ChildDetailViewModel.swift
//  NurseryConnect
//

import Foundation
import Observation

@Observable
@MainActor
final class ChildDetailViewModel {
    // MARK: - State
    var entries: [DiaryEntry] = []
    var isLoading: Bool = false
    var errorMessage: String?
    var showToast: Bool = false
    var toastMessage: String = ""

    // MARK: - Sheet state
    var showDiaryForm: Bool = false
    var selectedDiaryType: DiaryEntryType = .activity

    // MARK: - Dependencies
    let child: Child
    private let diaryService: DiaryService

    init(child: Child, diaryService: DiaryService) {
        self.child = child
        self.diaryService = diaryService
    }

    // MARK: - Actions
    func loadEntries() async {
        isLoading = true
        defer { isLoading = false }
        do {
            entries = try diaryService.entries(for: child)
        } catch {
            errorMessage = "Could not load diary entries. Please try again."
        }
    }

    func presentDiaryForm(type: DiaryEntryType) {
        selectedDiaryType = type
        showDiaryForm = true
    }

    func onEntrySaved() async {
        await loadEntries()
        toastMessage = "Entry saved successfully"
        showToast = true
    }
}
