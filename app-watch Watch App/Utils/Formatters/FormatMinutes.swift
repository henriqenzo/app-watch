//
//  FormatMinutes.swift
//  app-watch Watch App
//
//  Created by Filipi Romão on 19/08/26.
//

import Foundation

class FormatMinutes {
    static func clock(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
