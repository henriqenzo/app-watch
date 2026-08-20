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
        VStack(spacing: 14) {
            VStack(spacing: 12) {
                Image(systemName: "figure.run")
                    .font(.title2)
                    .background(
                        Circle()
                            .fill(Color.accent.opacity(0.4))
                            .frame(width: 50, height: 50))
                Text("Vamos correr?")
                    .font(.headline)
                    .fontWeight(.bold)
            }
            
            VStack(spacing: 8) {
                Button {
                    
                } label: {
                    Text("Iniciar treino guiado")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                        .padding(.vertical, 10)
                    
                }
                .frame(maxWidth: .infinity)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 13))
                .buttonStyle(.plain)
                
                Button {
                    
                } label: {
                    Text("Iniciar treino livre")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.vertical, 10)
                }
                .frame(maxWidth: .infinity)
                .background(.backgroundLight)
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
