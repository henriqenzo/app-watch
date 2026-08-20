//
//  GuideRunViewModel.swift
//  app-watch Watch App
//
//  Created by Filipi Romão on 20/08/26.
//

import Combine
import Foundation

class FreeRunViewModel: ObservableObject {
    @Published var isRunning: Bool = true

    func pauseResumeRunning() {
        isRunning.toggle()
    }

    func stopRunning() {
        if isRunning {
            print("Tem que pausar primeiro")
        } else {
            print("Treino finalizado")
        }
    }

    func editRunning() {
        print("Vai editar")
    }

}
