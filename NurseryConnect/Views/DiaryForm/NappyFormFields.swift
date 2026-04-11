//
//  NappyFormFields.swift
//  NurseryConnect
//

import SwiftUI

struct NappyFormFields: View {
    @Binding var nappyType: String

    private let nappyTypes = ["wet", "dirty", "both"]

    var body: some View {
        Picker("Type", selection: $nappyType) {
            Text("Select").tag("")
            ForEach(nappyTypes, id: \.self) { type in
                Text(type.capitalized).tag(type)
            }
        }
        .pickerStyle(.segmented)
    }
}
