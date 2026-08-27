//
//  HomeView.swift
//  app-watch Watch App
//
//  Created by Débora Cristina Silva Ferreira on 19/08/26.
//

import Foundation
import SwiftUI

enum RunType {
    case guided
    case free
}

struct HomeView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(RunFlowState.self) private var flow
    
    @State private var selectedTab = 0
    @State private var showSettingsView = false
    @State private var weatherViewModel: WeatherConditionViewModel
    
    private let makeGuideRunViewModel: (Int?) -> GuideRunViewModel
    private let makeFreeRunViewModel: () -> FreeRunViewModel
    private let makeSettingsViewModel: () -> SettingsViewModel
    
    init(
        weatherViewModel: WeatherConditionViewModel,
        makeGuideRunViewModel: @escaping (Int?) -> GuideRunViewModel,
        makeFreeRunViewModel: @escaping () -> FreeRunViewModel,
        makeSettingsViewModel: @escaping () -> SettingsViewModel
    ) {
        _weatherViewModel = State(initialValue: weatherViewModel)
        self.makeGuideRunViewModel = makeGuideRunViewModel
        self.makeFreeRunViewModel = makeFreeRunViewModel
        self.makeSettingsViewModel = makeSettingsViewModel
    }
    
    var body: some View {
        @Bindable var flow = flow
        NavigationStack(path: $flow.path) {
            TabView(selection: $selectedTab) {
                homeTab.tag(0)
                WeatherConditionContainerView(viewModel: weatherViewModel).tag(1)
            }
            .tabViewStyle(.page)
            .navigationDestination(for: RunFlowRoute.self) { route in
                RunFlowDestinationView(
                    route: route,
                    makeGuideRunViewModel: makeGuideRunViewModel,
                    makeFreeRunViewModel: makeFreeRunViewModel
                )
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showSettingsView = true } label: {
                        Image(systemName: "gearshape.fill")
                    }
                }
            }
            .sheet(isPresented: $showSettingsView) {
                SettingsView(settingsViewModel: makeSettingsViewModel())
            }
        }
        .onOpenURL { url in
            
            guard url.scheme == "myapp", url.host == "weather" else { return }
            
            flow.path = NavigationPath()
            
            selectedTab = 1
            
        }
        .task { weatherViewModel.requestWeather() }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active { weatherViewModel.requestWeather() }
        }
    }
    
    private var homeTab: some View {
        VStack(spacing: AppSizes.xmedium) {
            VStack(spacing: AppSizes.medium) {
                Image(systemName: "figure.run")
                    .font(.title2)
                    .background(Circle().fill(Color.brandPrimary.opacity(0.4)).frame(width: 50, height: 50))
                Text("Vamos correr?").font(.headline).fontWeight(.bold)
            }
            VStack(spacing: AppSizes.medium) {
                PrimaryButtonComponent(label: "Iniciar treino guiado", variantStyle: .primary) {
                    flow.type = .guided
                    flow.goTo(.goal)
                }
                PrimaryButtonComponent(label: "Iniciar treino livre", variantStyle: .secondary) {
                    flow.type = .free
                    flow.goTo(.goal)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var container = AppContainer()
        
        var body: some View {
            HomeView(
                weatherViewModel: container.makeWeatherConditionViewModel(),
                makeGuideRunViewModel: {_ in 
                    container.makeGuideRunViewModel()
                },
                makeFreeRunViewModel: container.makeFreeRunViewModel,
                makeSettingsViewModel: container.makeSettingsViewModel
            )
        }
    }
    return PreviewWrapper()
}
