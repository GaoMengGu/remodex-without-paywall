// FILE: OnboardingView.swift
// Purpose: Minimal pairing entry screen.
// Layer: View
// Exports: OnboardingView
// Depends on: SwiftUI, PrimaryCapsuleButton

import SwiftUI

struct OnboardingView: View {
    let onScanQRCode: () -> Void
    let onPairWithCode: () -> Void

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            actionButtons
        }
        .preferredColorScheme(.dark)
    }

    private var actionButtons: some View {
        VStack(spacing: 10) {
            PrimaryCapsuleButton(
                title: "扫描二维码",
                systemImage: "qrcode",
                action: onScanQRCode
            )

            secondaryCapsuleButton(
                title: "通过代码绑定",
                systemImage: "keyboard",
                action: onPairWithCode
            )
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 12)
        .frame(maxHeight: .infinity, alignment: .center)
    }

    private func secondaryCapsuleButton(title: String, systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 10) {
                RemodexIcon.image(systemName: systemImage)
                    .font(.system(size: 15, weight: .semibold))

                Text(title)
                    .font(AppFont.body(weight: .semibold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.1))
            )
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(0.18), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Previews

#Preview("Full Flow") {
    OnboardingView(
        onScanQRCode: {
            print("Scan tapped")
        },
        onPairWithCode: {
            print("Code tapped")
        }
    )
}

#Preview("Light Override") {
    OnboardingView(
        onScanQRCode: {
            print("Scan tapped")
        },
        onPairWithCode: {
            print("Code tapped")
        }
    )
    .preferredColorScheme(.light)
}
