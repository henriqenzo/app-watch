//
//  FinishedView.swift
//  app-watch
//
//  Created by Jota Pe on 19/08/26.
//

import SwiftUI

struct FinishedView: View {

    var onSeeSummary: () -> Void = {}

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            // Confetes ficam atrás do conteúdo e não capturam toques.
            ConfettiRainView()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer(minLength: 0)

                // MARK: - Selo de conclusão
                ZStack {
                    Circle()
                        .fill(Color.accentPink.opacity(0.18))
                        .frame(width: 76, height: 76)

                    Image(systemName: "checkmark")
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundStyle(Color.accentPink)
                }

                // MARK: - Textos
                Text("Parabéns!")
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                    .padding(.top, 12)

                Text("Treino concluído")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.top, 2)

                Spacer(minLength: 0)

                ///TODO: trocar botão depois
                Button(action: onSeeSummary) {
                    Text("Ver resumo")
                        .font(.headline)
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.accentPink, in: Capsule())
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 8)
        }
    }
}

// MARK: - Confetes

private struct ConfettiRainView: View {

    /// Quanto tempo a chuva dura, do primeiro ao último papel sumir.
    private static let totalDuration: Double = 4

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var pieces = ConfettiPiece.make(count: 22) //quantidade de confetes
    @State private var startedAt = Date()
    @State private var isFinished = false

    var body: some View {
        Group {
            // Respeita "Reduzir Movimento": sem confetes, sem timeline rodando.
            if !reduceMotion {
                TimelineView(.animation(minimumInterval: 1 / 30, paused: isFinished)) { timeline in
                    Canvas { context, size in
                        let elapsed = timeline.date.timeIntervalSince(startedAt)
                        for piece in pieces {
                            draw(piece, at: elapsed, in: size, with: context)
                        }
                    }
                }
            }
        }
        .allowsHitTesting(false)
        .task {
            startedAt = .now
            try? await Task.sleep(for: .seconds(Self.totalDuration))
            isFinished = true
        }
    }

    /// Desenha um confete na posição correspondente ao instante `elapsed`.
    private func draw(
        _ piece: ConfettiPiece,
        at elapsed: Double,
        in size: CGSize,
        with context: GraphicsContext
    ) {
        let progress = CGFloat((elapsed - piece.delay) / piece.fallDuration)
        // Ainda não começou a cair, ou já saiu pela parte de baixo da tela.
        guard progress > 0, progress < 1 else { return }

        // Sai de um pouco acima do topo e termina um pouco abaixo da base.
        let y = -12 + progress * (size.height + 24)
        // Balanço lateral para a queda não ficar em linha reta.
        let swayOffset = CGFloat(sin(Double(progress) * 3 * .pi + piece.swayPhase)) * piece.swayAmplitude
        let x = piece.xRatio * size.width + swayOffset
        let angle = piece.spins * 360 * Double(progress)
        // Desaparece no último quarto da queda.
        let opacity = progress > 0.75 ? (1 - progress) / 0.25 : 1

        context.drawLayer { layer in
            layer.translateBy(x: x, y: y)
            layer.rotate(by: .degrees(angle))
            layer.fill(
                Path(
                    roundedRect: CGRect(
                        x: -piece.width / 2,
                        y: -piece.height / 2,
                        width: piece.width,
                        height: piece.height
                    ),
                    cornerRadius: 1
                ),
                with: .color(piece.color.opacity(opacity))
            )
        }
    }
}

/// Um papel de confete. Todos os valores são sorteados uma única vez, na
/// criação, para que a queda de cada papel seja estável durante a animação.
private struct ConfettiPiece: Identifiable {
    let id: Int
    /// Posição horizontal inicial, de 0 (esquerda) a 1 (direita).
    let xRatio: CGFloat
    /// Atraso até este papel começar a cair.
    let delay: Double
    /// Tempo que leva para atravessar a tela inteira.
    let fallDuration: Double
    let width: CGFloat
    let height: CGFloat
    let color: Color
    /// Voltas completas que o papel gira durante a queda.
    let spins: Double
    let swayAmplitude: CGFloat
    /// Deslocamento inicial do balanço, para os papéis não oscilarem juntos.
    let swayPhase: Double

    static func make(count: Int) -> [ConfettiPiece] {
        let palette: [Color] = [
            .accentPink,
            .accentPink.opacity(0.65),
            .white,
            .white.opacity(0.75)
        ]

        return (0..<count).map { index in
            ConfettiPiece(
                id: index,
                xRatio: .random(in: 0.02...0.98),
                delay: .random(in: 0...1.1),
                fallDuration: .random(in: 1.6...2.6),
                width: .random(in: 3...5.5),
                height: .random(in: 5...9),
                color: palette[index % palette.count],
                spins: .random(in: 0.8...2.4),
                swayAmplitude: .random(in: 4...14),
                swayPhase: .random(in: 0...(2 * .pi))
            )
        }
    }
}

// TODO: mover para o arquivo de cores/tema quando o design system for criado.
private extension Color {
    static let accentPink = Color(red: 1.0, green: 0.25, blue: 0.53)
}

#Preview {
    FinishedView()
}
