//
//  WheelColumnView.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 20/08/26.
//

//  Requer watchOS 10+ (scrollPosition/scrollTargetLayout/scrollTargetBehavior).

import SwiftUI

struct WheelColumnView<Value: Hashable>: View {
    let values: [Value]
    @Binding var selection: Value
    /// Sufixo exibido SOMENTE no item selecionado (ex: "'" para minutos, "\"" para segundos).
    var suffix: String? = nil
    /// Quando `true`, desenha um RoundedRectangle de highlight atrás do item selecionado.
    var isFocused: Bool = false
    let label: (Value) -> Text

    private let rowHeight: CGFloat = 32

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(values, id: \.self) { value in
                    let isSelected = value == selection

                    HStack(alignment: .lastTextBaseline, spacing: 1) {
                        label(value)
                        if let suffix, isSelected {
                            Text(suffix)
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundStyle(.white)
                        }
                    }
                    .foregroundStyle(isSelected ? Color.white : Color.secondary.opacity(0.60))
                    .fontWeight(isSelected ? .bold : .regular)
                    .frame(height: rowHeight)
                    .frame(maxWidth: .infinity)
                    .background {
                        if isFocused && isSelected {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color.white.opacity(0.12))
                        }
                    }
                    .id(value)
                }
            }
            // Padding dentro do LazyVStack permite que o 1º e o último item
            // sejam centralizados no viewport de 3 linhas.
            .padding(.vertical, rowHeight)
            .scrollTargetLayout()
        }
        .scrollPosition(
            id: Binding(
                get: { Optional(selection) },
                set: { if let newValue = $0 { selection = newValue } }
            ),
            anchor: .center   // Item selecionado sempre centralizado (1 acima, 1 abaixo)
        )
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicators(.hidden)
        .frame(height: rowHeight * 3)
        .contentShape(Rectangle())
        .clipped()
        .mask(
            LinearGradient(
                stops: [
                    .init(color: .clear,               location: 0),
                    .init(color: .black.opacity(0.70), location: 0.15),
                    .init(color: .black,               location: 0.28),
                    .init(color: .black,               location: 0.72),
                    .init(color: .black.opacity(0.70), location: 0.85),
                    .init(color: .clear,               location: 1)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}
