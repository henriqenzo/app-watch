//
//  FreeRunSessionView.swift
//  app-watch Watch App
//
//  Created by Filipi Romão on 26/08/26.
//

import SwiftUI

struct FreeRunSessionView: View {

    @State private var viewModel: RunViewModelProtocol
    @State private var selection = 1

    init(viewModel: RunViewModelProtocol) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        TabView(selection: $selection) {
            LiveRunView(viewModel: viewModel)
                .tag(0)
            ControlFreeView(freeViewModel: viewModel)
                .tag(1)
        }
        .tabViewStyle(.page)
        .background(Color.background.ignoresSafeArea())
        .task {
            viewModel.startRunning()
        }
    }
}

