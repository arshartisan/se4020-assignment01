//
//  Date+Formatting.swift
//  NurseryConnect
//

import Foundation

extension Date {

    /// Relative format: "2 hours ago", "Yesterday", etc.
    func relativeFormatted() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: .now)
    }

    /// Absolute format: "14:30, 11 Apr 2026"
    func absoluteFormatted() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm, d MMM yyyy"
        formatter.locale = Locale(identifier: "en_GB")
        return formatter.string(from: self)
    }

    /// Short date: "11 Apr 2026"
    func shortDateFormatted() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "en_GB")
        return formatter.string(from: self)
    }

    /// Time only: "14:30"
    func timeFormatted() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "en_GB")
        return formatter.string(from: self)
    }
}
