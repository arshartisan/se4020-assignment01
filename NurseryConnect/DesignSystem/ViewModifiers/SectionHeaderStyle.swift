//
//  SectionHeaderStyle.swift
//  NurseryConnect
//

import SwiftUI

struct SectionHeaderStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.appHeadline)
            .foregroundColor(.appTextSecondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension View {
    func sectionHeaderStyle() -> some View {
        modifier(SectionHeaderStyle())
    }
}
