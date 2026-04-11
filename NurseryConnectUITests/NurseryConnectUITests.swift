//
//  NurseryConnectUITests.swift
//  NurseryConnectUITests
//

import XCTest

final class NurseryConnectUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    /// Helper: navigate from roster to the first child's detail view
    @MainActor
    private func navigateToFirstChild() {
        let firstCard = app.buttons["childRoster.card.0"]
        XCTAssertTrue(firstCard.waitForExistence(timeout: 5))
        firstCard.tap()

        let activityButton = app.buttons["quickAction.activity"]
        XCTAssertTrue(activityButton.waitForExistence(timeout: 5))
    }

    // MARK: - Test 1: Roster → Child Detail

    @MainActor
    func testRosterToChildDetail() throws {
        let grid = app.scrollViews.descendants(matching: .other)["childRoster.grid"]
        XCTAssertTrue(grid.waitForExistence(timeout: 5), "Child roster grid should appear")

        let firstCard = app.buttons["childRoster.card.0"]
        XCTAssertTrue(firstCard.waitForExistence(timeout: 5), "First child card should exist")
        firstCard.tap()

        let activityButton = app.buttons["quickAction.activity"]
        XCTAssertTrue(activityButton.waitForExistence(timeout: 5), "Quick action buttons should appear on child detail")
    }

    // MARK: - Test 2: Diary Entry Flow

    @MainActor
    func testDiaryEntryFlow() throws {
        navigateToFirstChild()

        let activityButton = app.buttons["quickAction.activity"]
        activityButton.tap()

        let activityField = app.textFields["Activity name"]
        XCTAssertTrue(activityField.waitForExistence(timeout: 5), "Activity name field should appear")
        activityField.tap()
        activityField.typeText("Story time")

        let saveButton = app.buttons["diaryForm.saveButton"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 5))
        saveButton.tap()

        // After save, sheet dismisses and we return to child detail
        XCTAssertTrue(activityButton.waitForExistence(timeout: 10), "Should return to child detail after save")
    }

    // MARK: - Test 3: Incident Reporting Flow

    @MainActor
    func testIncidentReportingFlow() throws {
        navigateToFirstChild()

        // Tap Report Incident
        let incidentButton = app.buttons["quickAction.reportIncident"]
        incidentButton.tap()

        // Verify the incident form loads with expected sections
        let navBar = app.navigationBars["Report Incident"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 5), "Incident form should appear")

        // Verify key form sections are present
        XCTAssertTrue(app.staticTexts["Category"].exists, "Category section should exist")
        XCTAssertTrue(app.staticTexts["Severity"].exists, "Severity section should exist")

        // Verify description text view is present
        let descriptionEditor = app.textViews.firstMatch
        XCTAssertTrue(descriptionEditor.waitForExistence(timeout: 5), "Description field should appear")

        // Verify cancel button works to dismiss
        navBar.buttons["Cancel"].tap()

        // Back on child detail
        let activityButton = app.buttons["quickAction.activity"]
        XCTAssertTrue(activityButton.waitForExistence(timeout: 5), "Should return to child detail after cancel")
    }
}
