//
//  ControlGuideView.swift
//  app-watch Watch App
//
//  Created by Filipi Romão on 20/08/26.
//

import SwiftUI

struct ControlGuideView: View {
    @Environment(Router.self) private var router

    @State private var guideViewModel: RunViewModelProtocol

    init(guideViewModel: RunViewModelProtocol) {
        _guideViewModel = State(initialValue: guideViewModel)
    }

    var body: some View {
        HStack(spacing: AppSizes.xlarge) {
            ControllCellComponent(
                title: guideViewModel.isRunning ? "Pausar" : "Retomar",
                variant: guideViewModel.isRunning ? .pause : .play,
                action: guideViewModel.pauseResumeRunning
            )
            ControllCellComponent(
                title: "Encerrar",
                variant: guideViewModel.isRunning ? .deactive : .stop,
                action: {
                         guideViewModel.stopRunning()
                        router.goTo(.finished)
                    
                }
            )
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var container = AppContainer()

        var body: some View {
            ControlGuideView(guideViewModel: container.makeGuideRunViewModel())
        }
    }
    return PreviewWrapper()
}
