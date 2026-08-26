//
//  HomeView.swift
//  app-watch Watch App
//
//  Created by Débora Cristina Silva Ferreira on 19/08/26.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @State private var showGoalView = false
    @State private var showWeatherCondition = false
    @State private var selectedTab = 0
    @State private var viewModel = WeatherConditionViewModel()
    @Environment(\.scenePhase) private var scenePhase
    @State private var router = Router()

    var body: some View {
        NavigationStack(path: $router.path) {
            TabView(selection: $selectedTab) {
                VStack(spacing: AppSizes.xmedium) {
                    VStack(spacing: AppSizes.medium) {
                        Image(systemName: "figure.run")
                            .font(.title2)
                            .background(
                                    Circle()
                                    .fill(Color.brandPrimary.opacity(0.4))
                                    .frame(width: 50, height: 50)
                            )
                        Text("Vamos correr?")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                    }
                    
                    VStack(spacing: AppSizes.medium) {
                        PrimaryButtonComponent(
                            label: "Iniciar treino guiado",
                            variantStyle: .primary
                        ) {
                            router.goTo(.goal)
                        }
                        
                        PrimaryButtonComponent(
                            label: "Iniciar treino livre",
                            variantStyle: .secondary
                            
                        ) {
                            
                            
                        }
                        
                    }
                    .padding(.horizontal)
                }
                .tag(0)
                
                WeatherConditionContainerView(viewModel: viewModel)
                    .tag(1)
                
            }
            .tabViewStyle(.page)
            .navigationDestination(for: Route.self) { route in
                
                switch route {
                    
                case .goal:
                    GoalView()

                case .selectPace:
                    SelectPaceView()
                case .selectDistance:
                    SelectDistanceView()
                case .startTraining:
                    StartTrainingView()
                case .liveRunView:
                    LiveRunView()
                        .toolbar(.hidden, for: .navigationBar)

                case .finished:
                    FinishedView{
                        router.goTo(.summary)
                    }
                    .toolbar(.hidden, for: .navigationBar)


                case .summary:
                    SummaryView{
                        router.goHome()
                    }
                    .navigationBarBackButtonHidden(true)

                case .selectTime:
                    SelectDurationView()
                }
                
            }
            .navigationDestination(isPresented: $showWeatherCondition) {
                WeatherConditionContainerView(viewModel: viewModel)
            }
            .onOpenURL { url in
                guard url.scheme == "myapp", url.host == "weather" else { return }
                selectedTab = 1
            }
        }
        .task {
            viewModel.requestWeather()
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                viewModel.requestWeather()
            }
        }
        .environment(router)
    }
}

#Preview {
    HomeView()
}
