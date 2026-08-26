//
//  ControlRunningView.swift
//  app-watch Watch App
//
//  Created by Filipi Romão on 20/08/26.
//

import SwiftUI

struct ControlRunningView: View {
    
    @State private var guideVM = AppContainer.shared.makeGuideRunViewModel()
    var onFinish: () -> Void
    var body: some View {
        HStack(spacing: AppSizes.xlarge) {
            ControllCellComponent(
                title: guideVM.isRunning ? "Pausar" : "Retomar",
                variant: guideVM.isRunning ? .pause : .play,
                action: guideVM.pauseResumeRunning
            )
            ControllCellComponent(
                title: "Encerrar",
                variant: guideVM.isRunning ? .deactive : .stop,
                action: {
                    guideVM.stopRunning()
                    onFinish()
                }
            )

        }
    }
}

#Preview {
    ControlRunningView(onFinish: { })
}
