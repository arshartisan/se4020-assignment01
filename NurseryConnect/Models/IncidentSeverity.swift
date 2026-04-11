//
//  IncidentSeverity.swift
//  NurseryConnect
//

import Foundation
import SwiftUI

enum IncidentSeverity: String, CaseIterable, Identifiable {
    case low
    case medium
    case high

    var id: String { rawValue }
    var displayName: String { rawValue.capitalized }

    var indicatorColor: Color {
        switch self {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
}
