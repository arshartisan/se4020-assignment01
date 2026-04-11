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
        case .low: return .appSuccess
        case .medium: return .appWarning
        case .high: return .appDanger
        }
    }
}
