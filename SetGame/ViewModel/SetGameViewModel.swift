//
//  SetGameViewModel.swift
//  SetGame
//
//  Created by Сергей Захаров on 06.10.2025.
//

import SwiftUI

class SetGameViewModel: ObservableObject {
    @Published var visibleCards: Int = 0
    @Published var matchResult: Bool? = nil
    @Published var dealAnimation = false
    private var game = SetModel()
    var cards: [Card] {
        game.deck
    }
    var discardPile: [Card] {
        game.discardPile
    }

    init() {
        startGame()
    }

    func tap(_ card: Card) {
        matchResult = game.pick(card)
        objectWillChange.send()
        if matchResult == true {
            dealAnimation = true
            withAnimation {
                visibleCards = cards.count
            }
        } else if matchResult == false {
            dealAnimation = false
        }
    }

    func dealFromDeck() {
        if let lastMatch = matchResult, lastMatch {
            let matchedCount = cards.filter { $0.isMatched }.count
            visibleCards -= matchedCount
        }
        let newCards = game.deal(3)
        withAnimation {
            visibleCards += newCards.count
        }
        dealAnimation = true
    }

    func startGame() {
        game = SetModel()
        let initialCards = game.deal(12)
        withAnimation {
            visibleCards = initialCards.count
        }
        dealAnimation = true
    }

    func shuffleDealtCards() {
        withAnimation {
            game.shuffleDealtCards()
            visibleCards = min(visibleCards, cards.count)
        }
        dealAnimation = true
    }

    func matchMessage() -> String {
        switch matchResult {
        case true:
            return "Match removed"
        case false:
            return "Not a match"
        case nil:
            return ""
        case .some(_):
            return ""
        }
    }

    func hueToColor(from hue: HueKind) -> Color {
        switch hue {
        case .purple: return .purple
        case .orange: return .orange
        case .cyan: return .cyan
        }
    }

    func computeCardWidth(
        count: Int,
        size: CGSize,
        atAspectRatio aspectRatio: CGFloat
    ) -> CGFloat {
        let count = CGFloat(count)
        var columnCount = 1.0
        repeat {
            let width = (size.width / columnCount)
            let height = width / aspectRatio
            let rowCount = (count / columnCount).rounded(.up)
            if rowCount * height < size.height {
                return (size.width / columnCount).rounded(.down)
            }
            columnCount += 1
        } while columnCount < count
        return min(size.width / count, size.height * aspectRatio).rounded(.down)
    }
}
