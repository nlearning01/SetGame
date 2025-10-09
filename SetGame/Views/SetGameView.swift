//
//  SetGameView.swift
//  SetGame
//
//  Created by Сергей Захаров on 06.10.2025.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var viewModel: SetGameViewModel
    @Namespace var cardNamespace

    var body: some View {
        VStack {
            HStack {
                deckView
                Spacer()
                discardPileView
            }
            .padding()
            cardGrid
                .animation(.easeInOut(duration: 0.5), value: viewModel.cards)
            Text(viewModel.matchMessage())
                .font(.headline)
            HStack {
                Button("Shuffle") {
                    withAnimation {
                        viewModel.shuffleDealtCards()
                    }
                }
                Button("Restart") {
                    withAnimation {
                        viewModel.startGame()
                    }
                }
            }
            .padding()
        }
    }

    var cardGrid: some View {
        GeometryReader { geometry in
            let activeCards = viewModel.cards
                .prefix(viewModel.visibleCards)
                .filter { !$0.isMatched }
            let shouldScroll = activeCards.count >= 30
            let cardWidth = shouldScroll
                ? 80.0
                : viewModel.computeCardWidth(
                    count: activeCards.count,
                    size: geometry.size,
                    atAspectRatio: 1 / 3
                )

            ScrollView(.vertical) {
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: cardWidth), spacing: 8)],
                    spacing: 8
                ) {
                    ForEach(activeCards) { card in
                        ShapeView(card: card, viewModel: viewModel)
                            .matchedGeometryEffect(id: card.id, in: cardNamespace)
                            .frame(width: cardWidth, height: cardWidth / (2 / 3))
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                            .scaleEffect(
                                viewModel.matchResult == true && card.isPicked ? 1.2 : 1.0
                            )
                            .rotation3DEffect(
                                .degrees(viewModel.matchResult == false && card.isPicked ? 360 : 0),
                                axis: (x: 0, y: 1, z: 0)
                            )
                            .onTapGesture {
                                withAnimation {
                                    viewModel.tap(card)
                                }
                            }
                    }
                }
                .padding(8)
            }
            .scrollDisabled(!shouldScroll)
        }
    }

    var deckView: some View {
        Button(action: {
            withAnimation {
                viewModel.dealFromDeck()
            }
        }) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray)
                .frame(width: 80, height: 120)
                .overlay(
                    Text("\(viewModel.cards.count)")
                        .foregroundColor(.white)
                )
        }
    }

    var discardPileView: some View {
        let lastDiscarded = viewModel.discardPile.last
        return Group {
            if let card = lastDiscarded {
                ShapeView(card: card, viewModel: viewModel)
                    .frame(width: 80, height: 120)
                    .matchedGeometryEffect(id: card.id, in: cardNamespace)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 80, height: 120)
            }
        }
    }
}

#Preview {
    SetGameView(viewModel: SetGameViewModel())
}
