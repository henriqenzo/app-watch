//
//  Router.swift
//  app-watch Watch App
//
//  Created by Débora Cristina Silva Ferreira on 26/08/26.
//

import Foundation
import SwiftUI

enum Route: Hashable {
    case goal
    case selectPace
    case selectDistance
    case selectTime
    case startTraining
    case liveRunView
    case finished
    case summary
}

@Observable
class Router {
    var path = NavigationPath()
    var isLiveRunPresented = false
    
    func goTo(_ route: Route) {
        path.append(route)
    }
    
    func goHome() {
        path = NavigationPath()
    }
}
