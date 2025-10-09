//
//  SetModel.swift
//  SetGame
//
//  Created by Сергей Захаров on 06.10.2025.
//

import Foundation

class SetModel {
    var deck: [Card] = []
    private var discardedCards: [Card] = []

    init() {
        deck = buildDeck()
    }

    func pick(_ card: Card) -> Bool? {
        guard let index = deck.firstIndex(where: { $0.id == card.id }) else {
            return false
        }
        let pickedCards = deck.filter { $0.isPicked }

        if pickedCards.count == 3 {
            if isValidMatch(pickedCards) {
                for picked in pickedCards {
                    if let matchIndex = deck.firstIndex(where: { $0.id == picked.id }) {
                        discardedCards.append(deck.remove(at: matchIndex))
                    }
                }
                deck[index].isPicked.toggle()
                return true
            } else {
                for picked in pickedCards {
                    if let deselectIndex = deck.firstIndex(where: { $0.id == picked.id }) {
                        deck[deselectIndex].isPicked = false
                    }
                }
                deck[index].isPicked.toggle()
                return false
            }
        }
        deck[index].isPicked.toggle()
        return nil
    }

    func deal(_ count: Int) -> [Card] {
        let dealtCards = Array(deck.prefix(count))
        deck.removeFirst(count)
        return dealtCards
    }

    func shuffleDealtCards() {
        let dealtCards = deck.filter { !$0.isMatched }
        deck = dealtCards.shuffled() + discardedCards
        discardedCards.removeAll()
    }

    private func isValidMatch(_ cards: [Card]) -> Bool {
        guard cards.count == 3 else { return false }

        let allFigures = Set(cards.map { $0.figure })
        let allHues = Set(cards.map { $0.hue })
        let allCounts = Set(cards.map { $0.count })
        let allFills = Set(cards.map { $0.fill })

        let validFigures = allFigures.count == 1 || allFigures.count == 3
        let validHues = allHues.count == 1 || allHues.count == 3
        let validCounts = allCounts.count == 1 || allCounts.count == 3
        let validFills = allFills.count == 1 || allFills.count == 3

        return validFigures && validHues && validCounts && validFills
    }

    private func buildDeck() -> [Card] {
        var deck: [Card] = []
        for figure in FigureKind.allCases {
            for hue in HueKind.allCases {
                for fill in FillKind.allCases {
                    for count in 1...3 {
                        deck.append(
                            Card(
                                figure: figure,
                                hue: hue,
                                fill: fill,
                                count: count
                            )
                        )
                    }
                }
            }
        }
        return deck.shuffled()
    }

    var discardPile: [Card] {
        discardedCards
    }
}

enum FigureKind: CaseIterable {
    case oval, diamond, circle
}

enum HueKind: CaseIterable {
    case purple, orange, cyan
}

enum FillKind: CaseIterable {
    case filled, outlined, striped
}

struct Card: Identifiable, Equatable {
    let id = UUID()
    let figure: FigureKind
    let hue: HueKind
    let fill: FillKind
    let count: Int
    var isMatched = false
    var isPicked = false
}
