//
//  WatchComplication.swift
//  WatchComplication
//
//  Created by Débora Cristina Silva Ferreira on 21/08/26.
//

import WidgetKit
import SwiftUI
import WeatherKit

struct Provider: AppIntentTimelineProvider {
    private let weatherManager = WeatherManager()
    private let calculator = WeatherConditionCalculator()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), condition: .good, temperature: 24)
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        let snapshot = WeatherConditionShared.load()
        return SimpleEntry(date: Date(), condition: snapshot?.condition ?? .good, temperature: snapshot?.temperature ?? 24)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var current = WeatherConditionShared.load()
        
        if current == nil || current!.isStale {
            if let refreshed = await fetchUsingLastKnownLocation() {
                current = refreshed
            }
        }
        
        let entry = SimpleEntry(date: Date(), condition: current?.condition ?? .good, temperature: current?.temperature ?? 24)
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!
        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }
    
    func recommendations() -> [AppIntentRecommendation<ConfigurationAppIntent>] {
        [AppIntentRecommendation(intent: ConfigurationAppIntent(), description: "Clima pra corrida")]
    }
    
    private func fetchUsingLastKnownLocation() async -> WeatherConditionSnapshot? {
        guard let lastLocation = WeatherConditionShared.loadLocation() else { return nil }
        
        do {
            let weather = try await weatherManager.fetchCurrentWeather(
                latitude: lastLocation.latitude,
                longitude: lastLocation.longitude
            )
            let condition = calculator.evaluate(weather)
            let temperature = Int(weather.temperature.converted(to: .celsius).value.rounded())
            
            let snapshot = WeatherConditionSnapshot(condition: condition, temperature: temperature, timestamp: Date())
            WeatherConditionShared.save(snapshot)
            return snapshot
        } catch {
            return nil
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let condition: WeatherCondition
    let temperature: Int
}

struct WatchComplicationEntryView: View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            Circle()
                .fill(entry.condition.color.opacity(0.2))
                .stroke(entry.condition.color, lineWidth: 2)
            
            Image(systemName: entry.condition.icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .fontWeight(.bold)
                .foregroundStyle(entry.condition.color)
                .padding(10)
        }
        .widgetURL(URL(string: "myapp://weather"))
    }
}

struct WatchComplication: Widget {
    let kind: String = "WatchComplication"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            WatchComplicationEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([
            .accessoryCircular
        ])
    }
}

#Preview(as: .accessoryCircular) {
    WatchComplication()
} timeline: {
    SimpleEntry(date: .now, condition: .good, temperature: 24)
    SimpleEntry(date: .now, condition: .extremeHeat, temperature: 35)
    SimpleEntry(date: .now, condition: .storm, temperature: 22)
}
