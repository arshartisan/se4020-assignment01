//
//  LoadingView.swift
//  NurseryConnect
//

import SwiftUI

struct LoadingView: View {
    var label: String? = nil

    var body: some View {
        VStack(spacing: AppSpacing.md) {
            ProgressView()
                .controlSize(.large)

            if let label {
                Text(label)
                    .font(.appBody)
                    .foregroundColor(.appTextSecondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    LoadingView(label: "Loading children…")
}
