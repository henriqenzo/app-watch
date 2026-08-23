//
//  WatchComplication.swift
//  WatchComplication
//
//  Created by Débora Cristina Silva Ferreira on 21/08/26.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date())
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }
        
        return Timeline(entries: entries, policy: .atEnd)
    }
    
    func recommendations() -> [AppIntentRecommendation<ConfigurationAppIntent>] {
        // Create an array with all the preconfigured widgets to show.
        [AppIntentRecommendation(intent: ConfigurationAppIntent(), description: "Example Widget")]
    }
    
    //    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
    //        // Generate a list containing the contexts this widget is relevant in.
    //    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct WatchComplicationEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            HStack(spacing: 8) {
                Image(systemName: WeatherCondition.hot.icon)
                    .foregroundStyle(WeatherCondition.hot.color)
                    .background(Circle().stroke(WeatherCondition.hot.color)
                        .frame(width: 50))
                Text(WeatherCondition.hot.title)
                    .font(.system(size: 12))
                    .foregroundStyle(WeatherCondition.hot.color)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(WeatherCondition.hot.color)
            )
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
            .accessoryRectangular,
            
        ])
    }
}


#Preview(as: .accessoryRectangular) {
    WatchComplication()
} timeline: {
    SimpleEntry(date: .now)
    SimpleEntry(date: .now)
}
