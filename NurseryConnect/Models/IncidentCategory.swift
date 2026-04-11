//
//  IncidentCategory.swift
//  NurseryConnect
//

import Foundation

enum IncidentCategory: String, CaseIterable, Identifiable {
    case minorAccident
    case firstAidRequired
    case safeguardingConcern
    case nearMiss
    case allergicReaction
    case medicalIncident

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .minorAccident:        return "Minor Accident"
        case .firstAidRequired:     return "Accident Requiring First Aid"
        case .safeguardingConcern:  return "Safeguarding Concern"
        case .nearMiss:             return "Near Miss"
        case .allergicReaction:     return "Allergic Reaction"
        case .medicalIncident:      return "Medical Incident"
        }
    }

    var sfSymbol: String {
        switch self {
        case .minorAccident:        return "bandage.fill"
        case .firstAidRequired:     return "cross.case.fill"
        case .safeguardingConcern:  return "shield.fill"
        case .nearMiss:             return "exclamationmark.triangle.fill"
        case .allergicReaction:     return "allergens"
        case .medicalIncident:      return "stethoscope"
        }
    }
}
