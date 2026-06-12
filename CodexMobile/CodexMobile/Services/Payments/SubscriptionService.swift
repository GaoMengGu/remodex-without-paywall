// FILE: SubscriptionService.swift
// Purpose: Exposes open app access while preserving legacy subscription call sites.
// Layer: Service
// Exports: SubscriptionService
// Depends on: Foundation, Observation

import Foundation
import Observation

enum SubscriptionBootstrapState: Equatable {
    case idle
    case loading
    case ready
    case failed
}

@MainActor
@Observable
final class SubscriptionService {
    private static let freeSendCountDefaultsKey = "codex.subscription.freeSendCount"

    private let defaults: UserDefaults

    private(set) var bootstrapState: SubscriptionBootstrapState = .ready
    private(set) var hasProAccess = true
    private(set) var freeSendCount = 0
    private(set) var isLoading = false
    private(set) var isPurchasing = false
    private(set) var isRestoring = false
    private(set) var lastErrorMessage: String?

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        defaults.removeObject(forKey: Self.freeSendCountDefaultsKey)
    }

    var remainingFreeSendAttempts: Int {
        Int.max
    }

    var hasFreeSendAccess: Bool {
        true
    }

    var hasAppAccess: Bool {
        true
    }

    func consumeFreeSendAttemptIfNeeded() {
        defaults.removeObject(forKey: Self.freeSendCountDefaultsKey)
        freeSendCount = 0
    }

    func bootstrap() async {
        resetOpenAccessState()
    }

    func refreshCustomerInfoSilently() async {
        resetOpenAccessState()
    }

    func loadOfferings() async {
        resetOpenAccessState()
    }

    func restorePurchases() async {
        resetOpenAccessState()
    }

    func syncPurchasesAfterOfferCodeRedemption() async {
        resetOpenAccessState()
    }

    private func resetOpenAccessState() {
        bootstrapState = .ready
        hasProAccess = true
        freeSendCount = 0
        isLoading = false
        isPurchasing = false
        isRestoring = false
        lastErrorMessage = nil
        defaults.removeObject(forKey: Self.freeSendCountDefaultsKey)
    }
}
