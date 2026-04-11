//
//  AppLogoLabelView.swift
//  NurseryConnect
//

import SwiftUI

struct AppLogoLabelView: View {
    var body: some View {
        HStack {
            Image(systemName: "heart.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("NurseryConnect")
                .font(.title2)
                .fontWeight(.semibold)
                .tracking(-1.5)
        }
    }
}

#Preview {
    AppLogoLabelView()
        .padding()
}
