//
//  BodyMapView.swift
//  NurseryConnect
//

import SwiftUI

struct BodyMapView: View {
    @Binding var selectedLocations: [BodyMapLocation]

    var body: some View {
        VStack(spacing: AppSpacing.md) {
            bodyDiagram
            selectedLocationsList
        }
    }

    // MARK: - Body Diagram

    private var bodyDiagram: some View {
        ZStack {
            // Stylised body outline using SF Symbols
            Image(systemName: AppIcons.bodyMap)
                .font(.system(size: 120))
                .foregroundColor(.appTextSecondary.opacity(0.2))

            // Tap regions arranged around the figure
            VStack(spacing: 2) {
                // Head and face row
                HStack(spacing: AppSpacing.md) {
                    locationDot(for: .head)
                    locationDot(for: .face)
                    locationDot(for: .neck)
                }

                // Arms and torso row
                HStack(spacing: AppSpacing.sm) {
                    VStack(spacing: 4) {
                        locationDot(for: .leftArm)
                        locationDot(for: .leftHand)
                    }
                    VStack(spacing: 4) {
                        locationDot(for: .torso)
                        locationDot(for: .back)
                    }
                    VStack(spacing: 4) {
                        locationDot(for: .rightArm)
                        locationDot(for: .rightHand)
                    }
                }

                // Legs row
                HStack(spacing: AppSpacing.lg) {
                    VStack(spacing: 4) {
                        locationDot(for: .leftLeg)
                        locationDot(for: .leftFoot)
                    }
                    VStack(spacing: 4) {
                        locationDot(for: .rightLeg)
                        locationDot(for: .rightFoot)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.md)
    }

    private func locationDot(for location: BodyMapLocation) -> some View {
        let isSelected = selectedLocations.contains(location)
        return Button {
            toggleLocation(location)
        } label: {
            Text(location.displayName)
                .font(.system(size: 9, weight: .semibold))
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .frame(minWidth: AppSpacing.minTapTarget, minHeight: 32)
                .foregroundColor(isSelected ? .white : .appTextSecondary)
                .background(isSelected ? Color.appDanger : Color.appSurface)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.appDanger : Color.appTextSecondary.opacity(0.3), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Selected Locations List

    @ViewBuilder
    private var selectedLocationsList: some View {
        if !selectedLocations.isEmpty {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text("Marked locations:")
                    .font(.appCaption)
                    .foregroundColor(.appTextSecondary)
                Text(selectedLocations.map(\.displayName).joined(separator: ", "))
                    .font(.appBody)
                    .foregroundColor(.appDanger)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    // MARK: - Helpers

    private func toggleLocation(_ location: BodyMapLocation) {
        if let index = selectedLocations.firstIndex(of: location) {
            selectedLocations.remove(at: index)
        } else {
            selectedLocations.append(location)
        }
    }
}

#Preview {
    @Previewable @State var locations: [BodyMapLocation] = [.head, .leftArm]
    BodyMapView(selectedLocations: $locations)
        .padding()
}
