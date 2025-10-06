//
//  SetGameViewModel.swift
//  SetGame
//
//  Created by Сергей Захаров on 06.10.2025.
//

import SwiftUI

class SetGameViewModel: ObservableObject {
    
    @Published var visibleCards: Int = 12
    private var matchResult: Bool? = nil
    private var game = SetModel()
    var cards: [Card] {
        game.deck
    }

    func tap(_ card: Card) {
        matchResult = game.pick(card)
        objectWillChange.send()
        if matchResult == true {
            dealCards()
        }
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

    func startGame() {
        game = SetModel()
        visibleCards = 12
    }

    func dealCards(_ count: Int = 3) {
        visibleCards = min(visibleCards + count, cards.count)
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
