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
    @State private var showEditGoals = false
    
    init(freeViewModel: RunViewModelProtocol) {
        _freeViewModel = State(initialValue: freeViewModel)
    }

    private var currentPaceMinutes: Int {
        guard let pace = freeViewModel.targetPace else { return 0 }
        return pace / 60
    }

    private var currentPaceSeconds: Int {
        guard let pace = freeViewModel.targetPace else { return 0 }
        return pace % 60
    }

    private var currentPPM: Int {
        Int(freeViewModel.metronomePPM)
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
                    showEditGoals = true
                }
            )
        }
        .sheet(isPresented: $showEditGoals) {
            NavigationStack {
                EditGoalsView(
                    initialPaceMinutes: currentPaceMinutes,
                    initialPaceSeconds: currentPaceSeconds,
                    initialPPM: currentPPM
                ) { paceMinutes, paceSeconds, ppm in
                    if let vm = freeViewModel as? FreeRunViewModel {
                        vm.updateGoals(
                            paceMinutes: paceMinutes,
                            paceSeconds: paceSeconds,
                            ppm: ppm
                        )
                    }
                }
            }
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
