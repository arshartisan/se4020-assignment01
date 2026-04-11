//
//  NapFormFields.swift
//  NurseryConnect
//

import SwiftUI

struct NapFormFields: View {
    @Binding var startTime: Date
    @Binding var endTime: Date

    var body: some View {
        DatePicker("Start time", selection: $startTime, displayedComponents: .hourAndMinute)
        DatePicker("End time", selection: $endTime, displayedComponents: .hourAndMinute)
    }
}
