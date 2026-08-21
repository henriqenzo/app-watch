//
//  LiveRunView.swift
//  app-watch
//
//  Created by Jota Pe on 19/08/26.
//

import SwiftUI

/// Tela exibida durante o treino em andamento. É compartilhada pelos dois
/// modos (livre e guiado) — o que muda entre eles são os dados recebidos.
struct LiveRunView: View {

    var heartRate: Int = 152
    var cadence: Int = 170
    var pace: String = "5'29\""
    var paceFeedback: PaceFeedback? = .onTarget
    var targetPace: String? = "5'30\""
    var elapsedTime: String = "54:32"
    var distance: String = "10,25"

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()

            VStack(spacing: 0) {
                sensorsRow

                Spacer(minLength: AppSizes.medium)

                paceBlock

                Spacer(minLength: AppSizes.medium)

                Divider()
                    .overlay(Color.textDisable.opacity(0.25))

                statsRow
                    .padding(.top, AppSizes.medium)
            }
            .padding(.horizontal, AppSizes.small)
        }
    }

    // MARK: - Sensores

    private var sensorsRow: some View {
        HStack(spacing: AppSizes.medium) {
            HStack(spacing: AppSizes.small) {
                Circle()
                    .fill(Color.danger)
                    .frame(width: 6, height: 6)

                metric(value: "\(heartRate)", unit: "bpm")
            }

            Spacer(minLength: 0)

            metric(value: "\(cadence)", unit: "rpm")
        }
    }

    private func metric(value: String, unit: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: AppSizes.xsmall) {
            Text(value)
                .font(AppTypography.title3)
                .foregroundStyle(Color.textPrimary)

            Text(unit)
                .font(AppTypography.caption)
                .foregroundStyle(Color.textDisable)
        }
        .lineLimit(1)
        .minimumScaleFactor(0.7)
    }

    // MARK: - Pace

    private var paceBlock: some View {
        VStack(spacing: AppSizes.xsmall) {
            Text("PACE ATUAL")
                .font(AppTypography.caption)
                .tracking(1)
                .foregroundStyle(Color.textDisable)

            Text(pace)
                .font(AppTypography.largeTitle)
                .foregroundStyle(Color.brandPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.6)

            if let paceFeedback {
                paceChip(paceFeedback)
                    .padding(.top, AppSizes.small)
            }
        }
    }

    private func paceChip(_ feedback: PaceFeedback) -> some View {
        HStack(spacing: AppSizes.small) {
            Image(systemName: feedback.icon)
                .font(.system(size: 10, weight: .bold))

            Text(chipLabel(for: feedback))
                .font(AppTypography.caption)
        }
        .foregroundStyle(feedback.color)
        .lineLimit(1)
        .minimumScaleFactor(0.7)
        .padding(.horizontal, AppSizes.medium)
        .padding(.vertical, AppSizes.small)
        .background(
            feedback.color.opacity(0.18),
            in: RoundedRectangle(cornerRadius: CGFloat(AppRadius.chipRadius))
        )
    }

    /// O alvo só aparece no modo guiado, onde existe um pace de referência.
    private func chipLabel(for feedback: PaceFeedback) -> String {
        guard let targetPace else { return feedback.title }
        return "\(feedback.title) · alvo \(targetPace)"
    }

    // MARK: - Tempo e distância

    private var statsRow: some View {
        HStack(alignment: .top, spacing: AppSizes.medium) {
            stat(value: elapsedTime, unit: nil, label: "TEMPO", alignment: .leading)

            Spacer(minLength: 0)

            stat(value: distance, unit: "km", label: "DISTÂNCIA", alignment: .trailing)
        }
    }

    private func stat(
        value: String,
        unit: String?,
        label: String,
        alignment: HorizontalAlignment
    ) -> some View {
        VStack(alignment: alignment, spacing: AppSizes.xsmall) {
            HStack(alignment: .firstTextBaseline, spacing: AppSizes.xsmall) {
                Text(value)
                    .font(AppTypography.title3)
                    .foregroundStyle(Color.textPrimary)

                if let unit {
                    Text(unit)
                        .font(AppTypography.caption)
                        .foregroundStyle(Color.textDisable)
                }
            }
            .lineLimit(1)
            .minimumScaleFactor(0.7)

            Text(label)
                .font(AppTypography.caption)
                .tracking(0.5)
                .foregroundStyle(Color.textDisable)
        }
    }
}

// MARK: - Feedback de pace

enum PaceFeedback {
    case onTarget
    case tooSlow
    case tooFast

    var title: String {
        switch self {
        case .onTarget: "no pace"
        case .tooSlow: "acelere"
        case .tooFast: "desacelere"
        }
    }

    var icon: String {
        switch self {
        case .onTarget: "checkmark"
        case .tooSlow: "arrow.up"
        case .tooFast: "arrow.down"
        }
    }

    var color: Color {
        switch self {
        case .onTarget: .success
        case .tooSlow, .tooFast: .alert
        }
    }
}

#Preview("Guiado · no pace") {
    LiveRunView()
}

#Preview("Guiado · acelere") {
    LiveRunView(pace: "6'02\"", paceFeedback: .tooSlow)
}

#Preview("Livre") {
    LiveRunView(paceFeedback: nil, targetPace: nil)
}
