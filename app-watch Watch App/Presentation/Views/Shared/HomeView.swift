//
//  HomeView.swift
//  app-watch Watch App
//
//  Created by Débora Cristina Silva Ferreira on 19/08/26.
//

import Foundation
import SwiftUI

struct HomeView: View {
    
    @Environment(AppContainer.self) private var container
    
    @State private var showGoalView = false
    @State private var showSettingsView = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: AppSizes.xmedium) {
                VStack(spacing: AppSizes.medium) {
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
                
                VStack(spacing: AppSizes.medium) {
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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSettingsView = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                }
            }
            .navigationDestination(isPresented: $showGoalView) {
                GoalView()
            }
            .sheet(isPresented: $showSettingsView) {
                SettingsView(settingsViewModel: container.makeSettingsViewModel()) 
            }
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var container = AppContainer()

        var body: some View {
            HomeView()
                .environment(container)
        }
    }
    return PreviewWrapper()
}
