//
//  ContentView.swift
//  NurseryConnect
//
//  Temporary placeholder — will be replaced by RootView in Phase 3.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "heart.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("NurseryConnect")
                .font(.title)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
