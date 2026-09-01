//
//  WeatherConditionShared.swift
//  app-watch Watch App
//
//  Created by Débora Cristina Silva Ferreira on 23/08/26.
//

import Foundation

struct WeatherConditionSnapshot: Codable {
    let condition: WeatherCondition
    let temperature: Int
    let timestamp: Date
    
    var isStale: Bool {
        Date().timeIntervalSince(timestamp) > 10 * 60
    }
}

struct LastLocation: Codable {
    let latitude: Double
    let longitude: Double
}

final class WeatherConditionShared {
    static let defaultsGroup: UserDefaults? = UserDefaults(suiteName: "group.br.com.crono.watchapp")
    
    private static let snapshotKey = "weatherSnapshot"
    private static let locationKey = "lastLocation"
    
    static func save(_ snapshot: WeatherConditionSnapshot) {
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        defaultsGroup?.set(data, forKey: snapshotKey)
    }
    
    static func load() -> WeatherConditionSnapshot? {
        guard let data = defaultsGroup?.data(forKey: snapshotKey) else { return nil }
        return try? JSONDecoder().decode(WeatherConditionSnapshot.self, from: data)
    }
    
    static func saveLocation(_ location: LastLocation) {
        guard let data = try? JSONEncoder().encode(location) else { return }
        defaultsGroup?.set(data, forKey: locationKey)
    }
    
    static func loadLocation() -> LastLocation? {
        guard let data = defaultsGroup?.data(forKey: locationKey) else { return nil }
        return try? JSONDecoder().decode(LastLocation.self, from: data)
    }
}
