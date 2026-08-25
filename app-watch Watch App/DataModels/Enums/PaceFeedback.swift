//
//  PaceFeedback.swift
//  app-watch Watch App
//
//  Created by Jota Pe on 21/08/26.
//

import SwiftUI

/// Faixa em que o pace atual se encontra em relação ao pace-alvo.
/// Só existe no modo guiado — no modo livre não há referência para comparar.
enum PaceFeedback: Equatable {
    case onTarget
    case tooSlow
    case tooFast

    var title: String {
        switch self {
        case .onTarget: "no pace"
        case .tooSlow: "acelere"
        case .tooFast: "desacelere"
        }
    }

    var icon: String {
        switch self {
        case .onTarget: "checkmark"
        case .tooSlow: "arrow.up"
        case .tooFast: "arrow.down"
        }
    }

    var color: Color {
        switch self {
        case .onTarget: .success
        case .tooSlow, .tooFast: .alert
        }
    }
}
