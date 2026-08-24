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

    @State private var viewModel: GuideRunViewModel

    init(viewModel: GuideRunViewModel = AppContainer.shared.makeGuideRunViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }

    // MARK: - Dados formatados

    private var heartRate: Int {
        viewModel.metricsWorkout.heartRate
    }

    /// Aproximação a partir dos passos acumulados — o HealthKit ainda não
    /// entrega cadência como métrica própria.
    private var cadence: Int {
        let duration = viewModel.metricsWorkout.duration
        guard duration > 0 else { return 0 }
        return Int(Double(viewModel.metricsWorkout.stepCount) / (duration / 60))
    }

    private var pace: String {
        guard let currentPace = viewModel.currentPace else { return "--'--\"" }
        return FormatMinutes.pace(currentPace)
    }

    private var paceFeedback: PaceFeedback? {
        viewModel.paceFeedback
    }

    private var targetPace: String? {
        viewModel.targetPace.map { FormatMinutes.pace($0) }
    }

    private var elapsedTime: String {
        FormatMinutes.clock(Int(viewModel.metricsWorkout.duration))
    }

    private var distance: String {
        String(format: "%.2f", viewModel.metricsWorkout.distanceWalkingRunning)
            .replacingOccurrences(of: ".", with: ",")
    }

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
        .task {
            viewModel.startRunning()
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
                .minimumScaleFactor(0.85)
                .layoutPriority(1)

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

// MARK: - Previews

/// Monta um ViewModel sobre velocidades sintéticas: o simulador do watchOS não
/// gera amostras de `.runningSpeed`.
private func previewViewModel(speeds: [Double], targetPace: Int?) -> GuideRunViewModel {
    let sessionManager = MockWorkoutSessionManager(speeds: speeds)
    let paceManager = PaceManager(workoutSessionManager: sessionManager)

    paceManager.onFeedbackChange = { reading in
        guard let feedback = reading.feedback, let delta = reading.deltaSecondsPerKm else { return }
        print("[feedback] \(feedback.title) — \(FormatMinutes.paceDelta(delta))")
    }

    return GuideRunViewModel(
        workoutManager: sessionManager,
        paceManager: paceManager,
        targetPace: targetPace
    )
}

/// 5'30"/km no alvo → 6'02"/km (+0'32") → parado.
#Preview("Guiado · sai do pace") {
    LiveRunView(
        viewModel: previewViewModel(
            speeds: Array(repeating: 3.03, count: 8)
                + Array(repeating: 2.76, count: 12)
                + Array(repeating: 0, count: 4),
            targetPace: AppContainer.defaultTargetPace
        )
    )
}

#Preview("Livre · sem alvo") {
    LiveRunView(
        viewModel: previewViewModel(
            speeds: Array(repeating: 3.03, count: 8),
            targetPace: nil
        )
    )
}
