//
//  RunConfiguration.swift
//  app-watch Watch App
//
//  Created by Débora Cristina Silva Ferreira on 27/08/26.
//

import Foundation
import SwiftUI

struct RunFlowDestinationView: View {
    let route: RunFlowRoute
    let makeGuideRunViewModel: (Int?) -> GuideRunViewModel
    let makeFreeRunViewModel: () -> FreeRunViewModel
    
    @Environment(RunFlowState.self) private var flow
    
    var body: some View {
        switch route {
        case .goal:
            GoalView()
        case .selectPace:
            SelectPaceView()
        case .selectDistance:
            SelectDistanceView()
        case .selectTime:
            SelectDurationView()
        case .startTraining:
            StartTrainingView(targetPace: 100)
        case .liveRun:
            liveRunView
        case .finished:
            FinishedView { flow.goTo(.summary) }
                .toolbar(.hidden, for: .navigationBar)
        case .summary:
            SummaryView { flow.goHome() }
                .navigationBarBackButtonHidden(true)
        }
    }
    
    @ViewBuilder
    private var liveRunView: some View {
        switch flow.type {
        case .guided:
            GuideRunSessionView(viewModel: makeGuideRunViewModel(flow.targetPace))
                .toolbar(.hidden, for: .navigationBar)
        case .free:
            FreeRunSessionView(viewModel: makeFreeRunViewModel())
                .toolbar(.hidden, for: .navigationBar)
        case .none:
            EmptyView()
        }
    }
}

enum RunFlowRoute: Hashable {
    case goal
    case selectPace
    case selectDistance
    case selectTime
    case startTraining
    case liveRun
    case finished
    case summary
}
