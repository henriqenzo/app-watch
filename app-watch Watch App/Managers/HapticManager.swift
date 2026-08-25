//
//  HapticManager.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 24/08/26.
//

import Foundation
import WatchKit

final class HapticManager: HapticManagerProtocol {

    private let device = WKInterfaceDevice.current()

    func playBeat() {
        device.play(.directionUp)
    }
}
