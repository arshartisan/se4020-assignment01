//
//  MockDispatchServiceTests.swift
//  NurseryConnectTests
//

import Testing
import Foundation
@testable import NurseryConnect

struct MockDispatchServiceTests {

    @Test
    func dispatchReturnsTrue() async {
        let service = MockDispatchService()
        let result = await service.dispatch(incidentID: UUID())
        #expect(result == true)
    }

    @Test
    func dispatchCompletes() async {
        let service = MockDispatchService()
        // Verify dispatch completes without hanging
        let result = await service.dispatch(incidentID: UUID())
        #expect(result == true)
    }
}
