//
//  IncidentDetailView.swift
//  NurseryConnect
//
//  Submitted incidents are immutable — supports audit trail per
//  Children Act 1989 safeguarding duty.
//

import SwiftUI
import SwiftData

struct IncidentDetailView: View {
    let incident: IncidentReport

    var body: some View {
        List {
            childSection
            categorySection
            whenWhereSection
            descriptionSection
            bodyMapSection
            actionTakenSection
            witnessesSection
            submissionSection
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Incident Detail")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Sections

    private var childSection: some View {
        Section("Child") {
            LabeledContent("Name") {
                Text(incident.child?.fullName ?? "Unknown")
            }
        }
    }

    private var categorySection: some View {
        Section("Classification") {
            LabeledContent("Category") {
                Label(incident.category.displayName, systemImage: incident.category.sfSymbol)
                    .foregroundColor(.appDanger)
            }
            LabeledContent("Severity") {
                HStack(spacing: AppSpacing.xs) {
                    Circle()
                        .fill(incident.severity.indicatorColor)
                        .frame(width: 10, height: 10)
                        .accessibilityHidden(true)
                    Text(incident.severity.displayName)
                }
            }
        }
    }

    private var whenWhereSection: some View {
        Section("When and Where") {
            LabeledContent("Occurred") {
                Text(incident.occurredAt.absoluteFormatted())
            }
            if !incident.location.isEmpty {
                LabeledContent("Location") {
                    Text(incident.location)
                }
            }
        }
    }

    private var descriptionSection: some View {
        Section("What Happened") {
            Text(incident.descriptionText)
                .font(.appBody)
        }
    }

    @ViewBuilder
    private var bodyMapSection: some View {
        if !incident.bodyMapLocations.isEmpty {
            Section("Injury Locations") {
                Text(incident.bodyMapLocations.map(\.displayName).joined(separator: ", "))
                    .font(.appBody)
                    .foregroundColor(.appDanger)
            }
        }
    }

    private var actionTakenSection: some View {
        Section("Action Taken") {
            Text(incident.immediateActionTaken)
                .font(.appBody)
        }
    }

    @ViewBuilder
    private var witnessesSection: some View {
        if !incident.witnesses.isEmpty {
            Section("Witnesses") {
                Text(incident.witnesses)
                    .font(.appBody)
            }
        }
    }

    private var submissionSection: some View {
        Section("Submission") {
            LabeledContent("Logged by") {
                Text(incident.loggedByKeyworker)
            }
            if let submitted = incident.submittedAt {
                LabeledContent("Submitted") {
                    Text(submitted.absoluteFormatted())
                }
            }
            LabeledContent("Dispatch") {
                Text(incident.dispatchStatus.capitalized)
                    .foregroundColor(incident.dispatchStatus == "dispatched" ? .appSuccess : .appWarning)
                    .fontWeight(.semibold)
            }
        }
    }
}

#Preview {
    let container = try! ModelContainerProvider.makeInMemoryContainer()
    let context = container.mainContext
    let seedService = SeedDataService(context: context)
    try! seedService.seedIfNeeded()
    let children = try! context.fetch(FetchDescriptor<Child>())
    let child = children.first!

    let incident = IncidentReport(
        child: child,
        category: .minorAccident,
        severity: .low,
        occurredAt: .now,
        location: "Outdoor play area",
        descriptionText: "Child tripped on uneven surface while running in the garden.",
        immediateActionTaken: "Applied cold compress. Comforted child. Monitored for 15 minutes.",
        witnesses: "Emma Wilson, James Taylor",
        loggedByKeyworker: "Sarah Mitchell"
    )
    incident.bodyMapLocations = [.leftArm, .leftHand]
    incident.submittedAt = .now
    incident.dispatchStatus = "dispatched"

    return NavigationStack {
        IncidentDetailView(incident: incident)
    }
    .modelContainer(container)
}
