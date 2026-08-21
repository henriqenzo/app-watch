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
    case deactive

    var background: Color {
        switch self {
        case .pause: return Color.alert
        case .stop: return Color.danger
        case .play: return Color.success
        case .deactive:
            return Color.backgroundLight
        }
    }
    var icon: String {
        switch self {
        case .pause: return "pause.fill"
        case .stop: return "stop.fill"
        case .play: return "play.fill"
        case .deactive: return "stop.fill"
        }
    }

}

struct ControlButtonComponent: View {
    var action: () -> Void
    var variantStyle: ControlButtonVariant
    var body: some View {
        ZStack {
            Circle()
                .fill(variantStyle.background)
                .frame(width: 60, height: 60)
                .blur(radius: 8)
                .opacity(0.35)

            Button(action: action) {
                Image(systemName: variantStyle.icon)
                    .foregroundStyle(Color.black)
                    .font(AppTypography.title3)
            }
            .frame(width: 60, height: 60)
            .background(variantStyle.background)
            .buttonStyle(.plain)
            .clipShape(Circle())
        }

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
