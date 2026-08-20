//
//  WorkoutSessionManager.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 20/08/26.
//

import HealthKit
import Combine

class WorkoutSessionManager: NSObject, ObservableObject {
    
    @Published var heartRate: Double = 0
    @Published var averageHeartRate: Double = 0
    @Published var activeEnergyBurned: Double = 0
    @Published var stepCount: Int = 0
    @Published var distanceWalkingRunning: Double = 0
    @Published var runningStrideLength: Double = 0
    
    @Published var elapsedTime: TimeInterval = 0
    
    @Published var sessionState: HKWorkoutSessionState = .notStarted
    @Published var isAuthorized: Bool = false
    
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?
    
    private var timer: AnyCancellable?
    
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        let typesToShare: Set = [
            HKQuantityType.workoutType()
        ]
        
        let typesToRead: Set = [
            HKQuantityType.workoutType(),
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .stepCount)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKQuantityType.quantityType(forIdentifier: .runningStrideLength)!
        ]
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.isAuthorized = success
            }
        }
    }
    
    func createSession() {
        do {
            let configuration = HKWorkoutConfiguration()
            configuration.activityType = .running
            configuration.locationType = .outdoor
            
            let session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            let builder = session.associatedWorkoutBuilder()
            
            builder.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)
            
            session.delegate = self
            builder.delegate = self
            
            self.session = session
            self.builder = builder
        } catch {
            print("Erro na criação da WorkoutSession: \(error.localizedDescription)")
        }
    }
    
    func startSession() async {
        if session == nil {
            createSession()
        }
        
        do {
            session?.prepare()
            
            let startDate = Date()
            session?.startActivity(with: startDate)
            try await builder?.beginCollection(at: startDate)
        } catch {
            print("Erro no início da WorkoutSession: \(error.localizedDescription)")
        }
    }
    
    func pauseSession() {
        session?.pause()
    }

    func resumeSession() {
        session?.resume()
    }
    
    func endSession() {
        session?.stopActivity(with: .now)
    }
    
    private func startTimer() {
        timer = Timer.publish(every: 0.05, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self, let builder = self.builder else { return }
                self.elapsedTime = builder.elapsedTime(at: Date())
            }
    }
    
    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }
    
    func resetWorkoutState() {
        stopTimer()
        heartRate = 0
        averageHeartRate = 0
        activeEnergyBurned = 0
        stepCount = 0
        distanceWalkingRunning = 0
        runningStrideLength = 0
        session = nil
        builder = nil
        sessionState = .notStarted
    }
}

extension WorkoutSessionManager: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.sessionState = toState
            
            switch toState {
            case .running:
                self.startTimer()
            case .paused:
                self.stopTimer()
                if let builder = self.builder {
                    self.elapsedTime = builder.elapsedTime(at: date)
                }
            case .stopped:
                builder?.endCollection(withEnd: date) { [weak self] success, error in
                    guard let self = self, success else {
                        if let error = error {
                            print("Erro ao encerrar coleta: \(error.localizedDescription)")
                        }
                        return
                    }
                    
                    self.builder?.finishWorkout { workout, error in
                        if let error = error {
                            print("Erro ao salvar o treino: \(error.localizedDescription)")
                        }
                        
                        self.session?.end()
                    }
                }
            case .ended:
                DispatchQueue.main.async {
                    self.resetWorkoutState()
                }
            default:
                break
            }
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: any Error) {
        print("Workout session falhou: \(error.localizedDescription)")
    }
}

extension WorkoutSessionManager: HKLiveWorkoutBuilderDelegate {
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else { continue }
            
            let statistics = workoutBuilder.statistics(for: quantityType)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                switch quantityType {
                // 1. Frequência Cardíaca (BPM - Mais recente)
                case HKQuantityType.quantityType(forIdentifier: .heartRate):
                    let bpmUnit = HKUnit.count().unitDivided(by: .minute())
                    let currentValue = statistics?.mostRecentQuantity()?.doubleValue(for: bpmUnit) ?? 0
                    let averageValue = statistics?.averageQuantity()?.doubleValue(for: bpmUnit) ?? 0
                    self.heartRate = currentValue
                    self.averageHeartRate = averageValue
                    
                // 2. Calorias Ativas (kcal - Soma acumulada)
                case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                    let calorieUnit = HKUnit.kilocalorie()
                    let value = statistics?.sumQuantity()?.doubleValue(for: calorieUnit) ?? 0
                    self.activeEnergyBurned = value
                    
                // 3. Contagem de Passos (Passos - Soma acumulada)
                case HKQuantityType.quantityType(forIdentifier: .stepCount):
                    let stepUnit = HKUnit.count()
                    let value = statistics?.sumQuantity()?.doubleValue(for: stepUnit) ?? 0
                    self.stepCount = Int(value)
                    
                // 4. Distância a Pé/Corrida (Metros - Soma acumulada)
                case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning):
                    let meterUnit = HKUnit.meter() // ou .meterUnit(with: .kilo) para km
                    let value = statistics?.sumQuantity()?.doubleValue(for: meterUnit) ?? 0
                    self.distanceWalkingRunning = value
                    
                // 5. Comprimento da Passada (Metros - Mais recente ou média)
                case HKQuantityType.quantityType(forIdentifier: .runningStrideLength):
                    let meterUnit = HKUnit.meter()
                    let value = statistics?.mostRecentQuantity()?.doubleValue(for: meterUnit) ?? 0
                    self.runningStrideLength = value
                    
                default:
                    break
                }
            }
        }
    }
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        
    }
}
