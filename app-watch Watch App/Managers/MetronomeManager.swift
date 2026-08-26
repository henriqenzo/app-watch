//
//  MetronomeManager.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 24/08/26.
//

import Foundation
import Combine
import AVFoundation

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

    static let minPPM: Double = 40
    static let maxPPM: Double = 240

    private let hapticManager: HapticManagerProtocol

    var audioFileName: String = "metronome-click"
    var audioFileExtension: String = "mp3"

    private var audioPlayer: AVAudioPlayer?

    private var timer: DispatchSourceTimer?

    private let timerQueue = DispatchQueue(
        label: "com.metronomocorrida.timerqueue",
        qos: .userInteractive
    )

    private var intervalNanoseconds: UInt64 = 0
    private var nextBeat: UInt64 = 0

    init(hapticManager: HapticManagerProtocol) {
        self.hapticManager = hapticManager
        setupAudioPlayer()
    }

    private func setupAudioPlayer() {
        guard let url = Bundle.main.url(
            forResource: audioFileName,
            withExtension: audioFileExtension
        ) else {
            print("[MetronomeManager] Arquivo de áudio '\(audioFileName).\(audioFileExtension)' não encontrado no bundle.")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.volume = 1.0
        } catch {
            print("[MetronomeManager] Erro ao carregar áudio: \(error)")
        }
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
            max(newValue, Self.minPPM),
            Self.maxPPM
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
        playAudio()
    }

    private func playAudio() {
        guard let player = audioPlayer else { return }
        if player.isPlaying {
            player.stop()
            player.currentTime = 0
        }
        player.play()
    }

    deinit {
        stop()
    }
}
