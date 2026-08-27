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
    
    @ViewBuilder
    var liveRunView: some View {
        if let sessionViewModel = flow.sessionViewModel {
            switch flow.type {
            case .guided:
                GuideRunSessionView(viewModel: sessionViewModel)
                
            case .free:
                FreeRunSessionView(viewModel: sessionViewModel)
                
            case .none:
                EmptyView()
            }
        } else {
            Color.clear.onAppear {
                switch flow.type {
                case .guided:
                    flow.sessionViewModel = makeGuideRunViewModel(flow.targetPace)
                    
                case .free:
                    flow.sessionViewModel = makeFreeRunViewModel()
                    
                case .none:
                    break
                }
            }
        }
    }
    
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
            StartTrainingView()
            
        case .liveRun:
            liveRunView
            
        case .finished:
            FinishedView {
                flow.goTo(.summary)
            }
            .toolbar(.hidden, for: .navigationBar)
            
        case .summary:
            if let sessionViewModel = flow.sessionViewModel {
                SummaryView(
                    viewModel: sessionViewModel,
                    onFinish: {
                        flow.goHome()
                    }
                )
                .navigationBarBackButtonHidden(true)
            }
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
