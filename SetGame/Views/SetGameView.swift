//
//  SetGameView.swift
//  SetGame
//
//  Created by Сергей Захаров on 06.10.2025.
//

import SwiftUI

struct SetGameView: View {
    
    @ObservedObject var viewModel: SetGameViewModel
    var body: some View {
        VStack {
            VStack {
                cardGrid
                    .animation(
                        .smooth(duration: 0.5),
                        value: viewModel.cards
                    )
            }
            .imageScale(.large)
            .padding()
            HStack {
                Text("\(viewModel.matchMessage())")
            }
            HStack {
                Button("Add cards") {
                    viewModel.dealCards(3)
                }
                Button("Restart") {
                    viewModel.startGame()
                }
            }
        }
    }

    var cardGrid: some View {
        GeometryReader { geometry in
            let activeCards = viewModel.cards
                .prefix(viewModel.visibleCards)
                .filter { !$0.isMatched }
            let shouldScroll = activeCards.count >= 30
            let cardWidth =
                shouldScroll
                ? 80.0
                : viewModel.computeCardWidth(
                    count: activeCards.count,
                    size: geometry.size,
                    atAspectRatio: 1 / 3
                )

            ScrollView(.vertical) {
                LazyVGrid(
                    columns: [
                        GridItem(.adaptive(minimum: cardWidth), spacing: 8)
                    ],
                    spacing: 8
                ) {
                    ForEach(activeCards) { card in
                        ShapeView(card: card, viewModel: viewModel)
                            .frame(
                                width: cardWidth,
                                height: cardWidth / (2 / 3)
                            )
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                            .onTapGesture {
                                viewModel.tap(card)
                            }
                    }
                }
                .padding(8)
            }
            .scrollDisabled(!shouldScroll)
        }
    }
}

#Preview {
    SetGameView(viewModel: SetGameViewModel())
}
