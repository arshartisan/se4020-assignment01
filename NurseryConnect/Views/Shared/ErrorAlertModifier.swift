//
//  ErrorAlertModifier.swift
//  NurseryConnect
//

import SwiftUI

struct ErrorAlertModifier: ViewModifier {
    @Binding var errorMessage: String?

    func body(content: Content) -> some View {
        content.alert(
            "Something went wrong",
            isPresented: .constant(errorMessage != nil),
            actions: {
                Button("OK", role: .cancel) { errorMessage = nil }
            },
            message: {
                Text(errorMessage ?? "")
            }
        )
    }
}

extension View {
    func errorAlert(_ message: Binding<String?>) -> some View {
        modifier(ErrorAlertModifier(errorMessage: message))
    }
}
