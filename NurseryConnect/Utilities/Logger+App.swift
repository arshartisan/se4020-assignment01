//
//  Logger+App.swift
//  NurseryConnect
//

import OSLog

extension Logger {
    private static let subsystem = "com.sliit.se4020.nurseryconnect"

    static let persistence = Logger(subsystem: subsystem, category: "persistence")
    static let services = Logger(subsystem: subsystem, category: "services")
    static let ui = Logger(subsystem: subsystem, category: "ui")
}
