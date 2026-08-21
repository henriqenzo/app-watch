//
//  WorkoutMetrics.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 20/08/26.
//

import Foundation

struct WorkoutMetrics {
    var heartRate: Metric = Metric.heartRate(bpm: 0)
    var averageHeartRate: Metric = Metric.averageHeartRate(bpm: 0)
    var activeEnergyBurned: Metric = Metric.calories(0)
    var stepCount: Metric = Metric.stepCount(0)
    var distanceWalkingRunning: Metric = Metric.distance(kilometers: 0)
    var runningStrideLength: Metric = Metric.strideLength(meters: 0)
}
