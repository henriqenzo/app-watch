//
//  HomeView.swift
//  app-watch Watch App
//
//  Created by Débora Cristina Silva Ferreira on 19/08/26.
//

import Foundation
import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 20) {
                Image(systemName: "figure.run")
                    .font(.title)
                    .background(
                        Circle()
                            .fill(Color.accent.opacity(0.4))
                            .frame(width: 60, height: 60))
                Text("Vamos correr?")
                    .font(.title3)
                    .fontWeight(.bold)
            }
            
            VStack(spacing: 8) {
                Button {
                    
                } label: {
                    Text("Iniciar treino guiado")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                        .padding(.vertical, 12)
                    
                }
                .frame(maxWidth: .infinity)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 13))
                .buttonStyle(.plain)
                
                Button {
                    
                } label: {
                    Text("Iniciar treino livre")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.vertical, 12)
                }
                .frame(maxWidth: .infinity)
                .background(Color.dark)
                .clipShape(RoundedRectangle(cornerRadius: 13))
                .buttonStyle(.plain)
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    HomeView()
}
