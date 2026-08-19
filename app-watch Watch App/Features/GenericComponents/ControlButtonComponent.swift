//
//  ControlButtonComponent.swift
//  app-watch Watch App
//
//  Created by Filipi Romão on 19/08/26.
//

import SwiftUI

enum ControlButtonVariant {
    case pause
    case stop
    case play

    var background: Color {
        switch self {
        case .pause: return Color.alert
        case .stop: return Color.danger
        case .play: return Color.success
        }
    }
    var icon: String {
        switch self {
        case .pause: return "pause.fill"
        case .stop: return "stop.fill"
        case .play: return "play.fill"
        }
    }

}

struct ControlButtonComponent: View {
    var action: () -> Void
    var variantStyle: ControlButtonVariant
    var body: some View {
        Button(
            action: action,
            label: {
                Image(systemName: "\(variantStyle.icon)")
                    .foregroundStyle(Color.black)
                    .font(AppTypography.largeTitle)
            }
        )
        .frame(width: 68, height: 68)
        .background(variantStyle.background)
        .buttonStyle(.plain)
        .clipShape(Circle())
    }
}

#Preview {
    ControlButtonComponent(
        action: {
            print("oi")
        },
        variantStyle: .play
    )
}
