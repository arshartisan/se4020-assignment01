//
//  MoodRating.swift
//  NurseryConnect
//

import Foundation

enum MoodRating: String, CaseIterable, Identifiable {
    case happy
    case settled
    case unsettled
    case poorly

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .happy: return "😊"
        case .settled: return "🙂"
        case .unsettled: return "😟"
        case .poorly: return "🤒"
        }
    }

    var displayName: String { rawValue.capitalized }
}
