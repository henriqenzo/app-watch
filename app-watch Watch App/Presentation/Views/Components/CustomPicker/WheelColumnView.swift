//
//  WheelColumnView.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 20/08/26.
//
//  Reescrito sem ScrollView: crown e dedo controlam o MESMO estado de
//  offset. Renderiza só uma JANELA de itens ao redor do centro (não a
//  lista inteira) pra suportar listas grandes (ex: 1000 itens de metros)
//  sem travar — cada linha é posicionada pelo índice absoluto, não
//  empilhada sequencialmente.

import SwiftUI

struct WheelColumnView<Value: Hashable>: View {
    let values: [Value]
    @Binding var selection: Value
    /// Sufixo exibido SOMENTE no item selecionado (ex: "'" para minutos, "\"" para segundos).
    var suffix: String? = nil
    /// Quando `true`, desenha um RoundedRectangle de highlight atrás do item selecionado.
    var isFocused: Bool = false
    let label: (Value) -> Text
    
    private let rowHeight: CGFloat = 30
    /// Quantas linhas renderizar pra cada lado do centro (buffer pro drag rápido).
    private let windowRadius: Int = 15
    
    @State private var dragOffset: CGFloat = 0
    @GestureState private var isDragging: Bool = false
    
    // Cache do índice selecionado — calculado 1x por mudança de `selection`.
    @State private var cachedSelectedIndex: Int = 0
    
    private var baseOffset: CGFloat {
        rowHeight * (1 - CGFloat(cachedSelectedIndex))
    }
    
    private var continuousIndex: CGFloat {
        CGFloat(cachedSelectedIndex) - dragOffset / rowHeight
    }
    
    private var centeredIndex: Int {
        Int(continuousIndex.rounded())
    }
    
    private var visibleIndexRange: ClosedRange<Int> {
        let lower = max(0, centeredIndex - windowRadius)
        let upper = min(values.count - 1, centeredIndex + windowRadius)
        return lower...upper
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            ForEach(Array(visibleIndexRange), id: \.self) { idx in
                let value = values[idx]
                let centered = idx == centeredIndex
                
                HStack(alignment: .center, spacing: 1) {
                    label(value)
                    if let suffix, centered {
                        Text(suffix)
                            .font(.system(size: 22, weight: .medium, design: .rounded))
                            .foregroundStyle(.white)
                    }
                }
                .foregroundStyle(centered ? Color.white : Color.secondary.opacity(0.60))
                .fontWeight(centered ? .bold : .regular)
                .frame(height: rowHeight)
                .frame(maxWidth: .infinity)
                .offset(y: CGFloat(idx) * rowHeight)
            }
        }
        .offset(y: baseOffset + dragOffset)
        .frame(height: rowHeight * 3, alignment: .top)
        .clipped()
        .overlay {
            if isFocused {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 55, height: rowHeight)
            }
        }
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
        .gesture(
            DragGesture(minimumDistance: 4)
                .updating($isDragging) { _, state, _ in state = true }
                .onChanged { value in
                    guard isFocused else { return }
                    dragOffset = value.translation.height
                }
                .onEnded { value in
                    guard isFocused else { return }
                    let indexDelta = Int((-value.translation.height / rowHeight).rounded())
                    let newIndex = min(max(0, cachedSelectedIndex + indexDelta), values.count - 1)
                    let newValue = values[newIndex]
                    
                    // Anima índice novo e zera o drag NA MESMA transação,
                    // pra não ter o "pulo pra posição antiga, depois desliza".
                    withAnimation(.easeOut(duration: 0.2)) {
                        cachedSelectedIndex = newIndex
                        dragOffset = 0
                    }
                    if selection != newValue {
                        selection = newValue
                    }
                }
        )
        .onAppear {
            updateCachedIndex()
        }
        .onChange(of: selection) { _, _ in
            // Mudança vinda da crown (ou de fora) — anima suavemente também.
            guard !isDragging else { return }
            withAnimation(.easeOut(duration: 0.2)) {
                updateCachedIndex()
            }
        }
    }
    
    private func updateCachedIndex() {
        cachedSelectedIndex = values.firstIndex(of: selection) ?? 0
    }
}
