//
//  DiaryEntryType.swift
//  NurseryConnect
//

import Foundation

enum DiaryEntryType: String, CaseIterable, Identifiable {
    case activity
    case meal
    case nap
    case nappy
    case wellbeing

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .activity: return "Activity"
        case .meal: return "Meal"
        case .nap: return "Nap"
        case .nappy: return "Nappy"
        case .wellbeing: return "Wellbeing"
        }
    }

    var sfSymbol: String {
        switch self {
        case .activity: return "figure.play"
        case .meal: return "fork.knife"
        case .nap: return "moon.zzz.fill"
        case .nappy: return "drop.fill"
        case .wellbeing: return "face.smiling"
        }
    }
}
