//
//  ControlFreeView.swift
//  app-watch Watch App
//
//  Created by Filipi Romão on 20/08/26.
//

import SwiftUI

struct ControlFreeView: View {
    @StateObject private var freeVM = FreeRunViewModel()
    var body: some View {
        VStack(spacing: AppSizes.large) {
            HStack(spacing: AppSizes.xlarge) {
                ControllCellComponent(
                    title: freeVM.isRunning ? "Pausar" : "Retomar",
                    variant: freeVM.isRunning ? .pause : .play,
                    action: freeVM.pauseResumeRunning
                )
                ControllCellComponent(
                    title: "Encerrar",
                    variant: freeVM.isRunning ? .deactive : .stop,
                    action: freeVM.stopRunning
                )
            }
            PrimaryButtonComponent(
                label: "Editar metas",
                variantStyle: .terciary,
                action: {
                    print("Editar metas")
                }
            )
        }
    }
}

#Preview {
    ControlFreeView()
}
