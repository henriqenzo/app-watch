//
//  MetronomeManagerProtocol.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 24/08/26.
//

import Foundation

protocol MetronomeManagerProtocol: AnyObject {
    var onPPMUpdate: ((Double) -> Void)? { get set }
    var onRunningStateUpdate: ((Bool) -> Void)? { get set }
    
    var ppm: Double { get }
    var isRunning: Bool { get }
    
    func start()
    func stop()
    func toggle()
    func updateBPM(_ newValue: Double)
    func increment(by amount: Double)
    func decrement(by amount: Double)
}
