//
//  ActivityFormFields.swift
//  NurseryConnect
//

import SwiftUI

struct ActivityFormFields: View {
    @Binding var activityName: String
    @Binding var durationMinutes: Int

    var body: some View {
        TextField("Activity name", text: $activityName)

        Stepper("Duration: \(durationMinutes) min", value: $durationMinutes, in: 5...180, step: 5)
    }
}
