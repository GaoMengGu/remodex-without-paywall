// FILE: SubscriptionServiceOpenAccessTests.swift
// Purpose: Verifies subscription compatibility state never blocks local app access.
// Layer: Unit Test
// Exports: SubscriptionServiceOpenAccessTests
// Depends on: XCTest, CodexMobile

import XCTest
@testable import CodexMobile

@MainActor
final class SubscriptionServiceOpenAccessTests: XCTestCase {
    func testAccessStaysOpenAfterLegacyConsumptionCalls() {
        let service = makeService()

        for _ in 0..<7 {
            service.consumeFreeSendAttemptIfNeeded()
        }

        XCTAssertTrue(service.hasAppAccess)
        XCTAssertTrue(service.hasFreeSendAccess)
        XCTAssertTrue(service.hasProAccess)
        XCTAssertEqual(service.freeSendCount, 0)
        XCTAssertEqual(service.bootstrapState, .ready)
    }

    func testBootstrapAndRestoreKeepAccessOpen() async {
        let service = makeService()

        await service.bootstrap()
        await service.restorePurchases()
        await service.refreshCustomerInfoSilently()

        XCTAssertTrue(service.hasAppAccess)
        XCTAssertTrue(service.hasProAccess)
        XCTAssertNil(service.lastErrorMessage)
        XCTAssertFalse(service.isLoading)
        XCTAssertFalse(service.isRestoring)
    }

    private func makeService() -> SubscriptionService {
        let suiteName = "SubscriptionServiceOpenAccessTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName) ?? .standard
        defaults.removePersistentDomain(forName: suiteName)
        return SubscriptionService(defaults: defaults)
    }
}
