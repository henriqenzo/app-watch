//
//  Router.swift
//  app-watch Watch App
//
//  Created by Débora Cristina Silva Ferreira on 26/08/26.
//

import Foundation
import SwiftUI

@Observable
final class RunFlowState {
    var path = NavigationPath()
    
    var type: RunType?
    var goal: GoalType?
    var targetPace: Int?
    var targetDistance: Double?
    var targetTime: TimeInterval?
    
    var sessionViewModel: RunViewModelProtocol?

    
    enum GoalType {
        case pace
        case distanceAndTime
    }
    
    func goTo(_ route: RunFlowRoute) {
        path.append(route)
    }
    
    func goHome() {
        path = NavigationPath()
        type = nil
        goal = nil
        targetPace = nil
        targetDistance = nil
        targetTime = nil
    }
    
    func deriveTargetPaceFromDistanceAndTime() {
        guard let targetDistance,
              targetDistance > 0,
              let targetTime else { return }
        
        
        let km = targetDistance / 1000
        let paceInSeconds = targetTime / km
        let paceInMinutes = paceInSeconds / 60
        
        targetPace = Int(paceInMinutes.rounded())
    }
}

