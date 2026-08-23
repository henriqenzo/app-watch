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
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                VStack(spacing: 12) {
                    VStack(spacing: 8) {
                        Image(systemName: "figure.run")
                            .font(.title2)
                            .background(
                                Circle()
                                    .fill(Color.brandPrimary.opacity(0.4))
                                    .frame(width: 50, height: 50))
                        Text("Vamos correr?")
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                    
                    VStack(spacing: 8) {
                        PrimaryButtonComponent(
                            label: "Iniciar treino guiado",
                            variantStyle: .primary
                        ) {
                            showGoalView = true
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
            .navigationDestination(isPresented: $showGoalView) {
                GoalView()
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
    }
}

#Preview {
    HomeView()
}
