//
//  ChildRosterCard.swift
//  NurseryConnect
//

import SwiftUI
import SwiftData

struct ChildRosterCard: View {
    let child: Child

    @State private var isPressed = false

    /// Stable pastel backgrounds derived from the child's name.
    private var cardColor: Color {
        let colors: [Color] = [
            Color(red: 0.69, green: 0.87, blue: 0.90),  // soft blue
            Color(red: 0.98, green: 0.85, blue: 0.65),  // soft yellow
            Color(red: 0.80, green: 0.90, blue: 0.75),  // soft green
            Color(red: 0.90, green: 0.80, blue: 0.93),  // soft purple
            Color(red: 0.95, green: 0.78, blue: 0.78),  // soft pink
        ]
        let index = abs(child.firstName.hashValue) % colors.count
        return colors[index]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            // Top row: initials avatar + badges
            HStack {
                initialsAvatar
                Spacer()
                badgesRow
            }

            Spacer()

            // Name
            Text(child.firstName)
                .font(.appHeadline)
                .foregroundColor(.black.opacity(0.8))
                .lineLimit(1)

            // Detail row
            HStack(spacing: AppSpacing.xs) {
                Text(formattedAge)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.black.opacity(0.5))
                Text("·")
                    .foregroundColor(.black.opacity(0.3))
                Text(child.roomName)
                    .font(.caption2)
                    .foregroundColor(.black.opacity(0.5))
                    .lineLimit(1)
            }
        }
        .padding(AppSpacing.md)
        .frame(minHeight: 140)
        .background(cardColor.opacity(0.45))
        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.cardCornerRadius))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(child.firstName), \(formattedAge), \(child.roomName)\(child.allergies.isEmpty ? "" : ", has allergies")")
        .scaleEffect(isPressed ? 0.96 : 1.0)
        .animation(.easeInOut(duration: 0.15), value: isPressed)
        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }

    // MARK: - Subviews

    private var initialsAvatar: some View {
        ZStack {
            Circle()
                .fill(.white.opacity(0.7))
                .frame(width: 38, height: 38)
            Text(String(child.firstName.prefix(1)))
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(.black.opacity(0.6))
        }
    }

    private var badgesRow: some View {
        HStack(spacing: AppSpacing.xs) {
            if !child.allergies.isEmpty {
                allergyBadge
            }
            consentIndicator
        }
    }

    private var allergyBadge: some View {
        HStack(spacing: 2) {
            Image(systemName: AppIcons.warning)
                .accessibilityHidden(true)
            Text("Allergy")
                .fontWeight(.semibold)
        }
        .font(.caption2)
        .foregroundColor(.white)
        .padding(.horizontal, 6)
        .padding(.vertical, 3)
        .background(Color.appDanger)
        .clipShape(Capsule())
        .accessibilityLabel("Has allergies")
    }

    private var consentIndicator: some View {
        Image(systemName: child.photographyConsent ? AppIcons.camera : "camera.fill")
            .font(.caption2)
            .padding(5)
            .foregroundColor(child.photographyConsent ? .black.opacity(0.6) : .black.opacity(0.2))
            .background(.white.opacity(0.5))
            .clipShape(Circle())
            .accessibilityLabel(child.photographyConsent ? "Photography consent given" : "No photography consent")
    }

    // MARK: - Helpers

    private var formattedAge: String {
        let months = child.ageInMonths
        let years = months / 12
        let remainingMonths = months % 12
        return "\(years)y \(remainingMonths)m"
    }
}

#Preview {
    let container = try! ModelContainerProvider.makeInMemoryContainer()
    let context = container.mainContext

    let child = Child(
        firstName: "Oliver",
        lastName: "Bennett",
        dateOfBirth: Calendar.current.date(byAdding: .year, value: -3, to: .now)!,
        roomName: "Sunshine Room",
        keyworkerName: "Sarah Mitchell",
        allergies: ["Peanuts"],
        photographyConsent: true
    )
    context.insert(child)

    return ChildRosterCard(child: child)
        .padding()
        .modelContainer(container)
}
