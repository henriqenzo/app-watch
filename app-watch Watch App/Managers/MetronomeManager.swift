//
//  MetronomeManager.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 24/08/26.
//

import Foundation
import Combine

final class MetronomeManager: MetronomeManagerProtocol {

    var onPPMUpdate: ((Double) -> Void)?
    var onRunningStateUpdate: ((Bool) -> Void)?
    
    private(set) var ppm: Double = 160 {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.onPPMUpdate?(self.ppm)
            }
        }
    }

    private(set) var isRunning: Bool = false {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.onRunningStateUpdate?(self.isRunning)
            }
        }
    }

    static let minBPM: Double = 40
    static let maxBPM: Double = 240

    private let hapticManager: HapticManagerProtocol

    private var timer: DispatchSourceTimer?

    private let timerQueue = DispatchQueue(
        label: "com.metronomocorrida.timerqueue",
        qos: .userInteractive
    )

    private var intervalNanoseconds: UInt64 = 0
    private var nextBeat: UInt64 = 0

    init(hapticManager: HapticManagerProtocol) {
        self.hapticManager = hapticManager
    }

    func start() {
        stop()

        guard ppm > 0 else { return }

        intervalNanoseconds = UInt64(
            (60.0 / ppm) * 1_000_000_000
        )

        isRunning = true

        nextBeat = DispatchTime.now().uptimeNanoseconds

        scheduleNextBeat()
    }

    func stop() {
        timer?.cancel()
        timer = nil

        isRunning = false
    }

    func toggle() {
        isRunning ? stop() : start()
    }

    func updateBPM(_ newValue: Double) {
        let clamped = min(
            max(newValue, Self.minBPM),
            Self.maxBPM
        )

        guard ppm != clamped else { return }

        ppm = clamped

        if isRunning {
            start()
        }
    }

    func increment(by amount: Double = 1) {
        updateBPM(ppm + amount)
    }

    func decrement(by amount: Double = 1) {
        updateBPM(ppm - amount)
    }

    private func scheduleNextBeat() {
        guard isRunning else { return }

        let newTimer = DispatchSource.makeTimerSource(
            queue: timerQueue
        )

        newTimer.schedule(
            deadline: DispatchTime(
                uptimeNanoseconds: nextBeat
            ),
            leeway: .milliseconds(3)
        )

        newTimer.setEventHandler { [weak self] in
            guard let self else { return }

            self.fireBeat()

            self.nextBeat += self.intervalNanoseconds

            self.timer?.cancel()
            self.timer = nil

            self.scheduleNextBeat()
        }

        newTimer.resume()

        timer = newTimer
    }

    private func fireBeat() {
        hapticManager.playBeat()
    }

    deinit {
        stop()
    }
}
