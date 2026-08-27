//
//  PaceManager.swift
//  app-watch Watch App
//
//  Created by Jota Pe on 21/08/26.
//

import Foundation


final class PaceManager: PaceManagerProtocol {

    var targetPace: Int? {
        didSet {
            guard targetPace != oldValue else { return }
            emit()
        }
    }

    private(set) var currentPace: Int?

    var onPaceUpdate: ((PaceReading) -> Void)?
    var onFeedbackChange: ((PaceReading) -> Void)?

    private let tolerance: Int
    private let smoothingFactor: Double
    
    private let minimumSpeed: Double = 0.5
    
    private var smoothedSpeed: Double?
    
    private var lastFeedback: PaceFeedback?
    
    init(workoutSessionManager: WorkoutSessionManagerProtocol, targetPace: Int? = nil, tolerance: Int = 15, smoothingFactor: Double = 0.3) {
        self.targetPace = targetPace
        self.tolerance = tolerance
        self.smoothingFactor = smoothingFactor
        
        workoutSessionManager.onSpeedUpdate = { [weak self] speed in
            self?.handle(speed: speed)
        }
    }
    
    func reset() {
        smoothedSpeed = nil
        currentPace = nil
        lastFeedback = nil
    }
    
    private func handle(speed: Double) {
        guard speed >= minimumSpeed else {
            smoothedSpeed = nil
            currentPace = nil
            emit()
            return
        }
        
        if let previous = smoothedSpeed {
            smoothedSpeed = previous + smoothingFactor * (speed - previous)
        } else {
            smoothedSpeed = speed
        }
        
        if let smoothedSpeed {
            currentPace = Int((1000 / smoothedSpeed).rounded())
        }
        
        emit()
    }

    private func emit() {
        let reading = makeReading()

        onPaceUpdate?(reading)

        guard let feedback = reading.feedback else { return }

        if feedback != lastFeedback {
            lastFeedback = feedback
            onFeedbackChange?(reading)
        }
    }

    private func makeReading() -> PaceReading {
        guard let currentPace, let targetPace else {
            return PaceReading(
                secondsPerKm: currentPace,
                feedback: nil,
                deltaSecondsPerKm: nil
            )
        }

        let delta = currentPace - targetPace

        let feedback: PaceFeedback
        if abs(delta) <= tolerance {
            feedback = .onTarget
        } else if delta > 0 {
            feedback = .tooSlow
        } else {
            feedback = .tooFast
        }

        return PaceReading(
            secondsPerKm: currentPace,
            feedback: feedback,
            deltaSecondsPerKm: delta
        )
    }
}
