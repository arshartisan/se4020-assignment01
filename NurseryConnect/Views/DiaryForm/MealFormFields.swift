//
//  MealFormFields.swift
//  NurseryConnect
//

import SwiftUI

struct MealFormFields: View {
    @Binding var mealType: String
    @Binding var portionConsumed: String

    private let mealTypes = ["breakfast", "lunch", "snack", "tea"]
    private let portions = ["all", "most", "half", "little", "none"]

    var body: some View {
        Picker("Meal", selection: $mealType) {
            Text("Select").tag("")
            ForEach(mealTypes, id: \.self) { type in
                Text(type.capitalized).tag(type)
            }
        }

        Picker("Portion eaten", selection: $portionConsumed) {
            Text("Select").tag("")
            ForEach(portions, id: \.self) { portion in
                Text(portion.capitalized).tag(portion)
            }
        }
    }
}
