//
//  ControlFreeView.swift
//  app-watch Watch App
//
//  Created by Filipi Romão on 20/08/26.
//

import SwiftUI

struct ControlFreeView: View {
    @Environment(RunFlowState.self) private var flow
    
    @State private var freeViewModel: RunViewModelProtocol
    
    init(freeViewModel: RunViewModelProtocol) {
        _freeViewModel = State(initialValue: freeViewModel)
    }
    
    var body: some View {
        VStack(spacing: AppSizes.large) {
            HStack(spacing: AppSizes.xlarge) {
                ControllCellComponent(
                    title: freeViewModel.isRunning ? "Pausar" : "Retomar",
                    variant: freeViewModel.isRunning ? .pause : .play,
                    action: freeViewModel.pauseResumeRunning
                )
                ControllCellComponent(
                    title: "Encerrar",
                    variant: freeViewModel.isRunning ? .deactive : .stop,
                    action: {
                        freeViewModel.stopRunning()
                        flow.goTo(.finished)
                    }
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
    struct PreviewWrapper: View {
        @State private var container = AppContainer()
        
        var body: some View {
            ControlFreeView(freeViewModel: container.makeFreeRunViewModel())
                .environment(RunFlowState())
        }
    }
    return PreviewWrapper()
}

#Preview {
    struct PreviewWrapper: View {
        @State private var container = AppContainer()

        var body: some View {
            ControlFreeView(freeViewModel: container.makeFreeRunViewModel())
        }
    }
    return PreviewWrapper()
}
