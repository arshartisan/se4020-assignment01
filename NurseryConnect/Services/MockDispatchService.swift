//
//  MockDispatchService.swift
//  NurseryConnect
//
//  Simulates an async call that — in a real production system — would
//  forward an incident report to the Setting Manager for countersignature
//  (per EYFS requirements). In this MVP it simply waits and returns true.
//

import Foundation

struct MockDispatchService {
    /// Simulates async dispatch with a 1.5s delay.
    /// Returns true on success. In production this would be a network call.
    func dispatch(incidentID: UUID) async -> Bool {
        try? await Task.sleep(for: .seconds(1.5))
        return true
    }
}
