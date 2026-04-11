//
//  ChildRosterViewModel.swift
//  NurseryConnect
//

import Foundation
import SwiftData
import Observation

@Observable
@MainActor
final class ChildRosterViewModel {
    // MARK: - State
    var children: [Child] = []
    var isLoading: Bool = false
    var errorMessage: String?

    // MARK: - Dependencies
    private let rosterService: ChildRosterService
    private let keyworkerName: String

    init(rosterService: ChildRosterService, keyworkerName: String = "Sarah Mitchell") {
        self.rosterService = rosterService
        self.keyworkerName = keyworkerName
    }

    // MARK: - Actions
    func loadRoster() async {
        isLoading = true
        defer { isLoading = false }
        do {
            children = try rosterService.fetchAssignedChildren(for: keyworkerName)
        } catch {
            errorMessage = "Could not load your assigned children. Please try again."
        }
    }
}
