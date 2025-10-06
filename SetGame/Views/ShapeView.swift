//
//  ShapeView.swift
//  SetGame
//
//  Created by Сергей Захаров on 06.10.2025.
//

import SwiftUI

struct ShapeView: View {
    var card: Card
    var viewModel: SetGameViewModel

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(
                    card.isPicked ? Color.yellow : Color.black,
                    lineWidth: 3
                )
                .background(
                    RoundedRectangle(cornerRadius: 15).fill(Color.white)
                )
                .shadow(radius: 5)
            VStack {
                ForEach(0..<card.count, id: \.self) { _ in
                    GeometryReader { geo in
                        let cardWidth = geo.size.width
                        let cardHeight = geo.size.height * CGFloat(card.count)
                        let shapeWidth = cardWidth * 0.6
                        let shapeHeight = cardHeight * 0.50

                        figureView(for: card.figure, fill: card.fill)
                            .frame(width: shapeWidth, height: shapeHeight)
                            .position(
                                x: geo.size.width / 2,
                                y: geo.size.height / 2
                            )
                    }
                    .aspectRatio(1, contentMode: .fit)
                    .padding(.vertical, 4)
                }
            }
            .padding(8)
        }
    }

    @ViewBuilder
    private func figureView(for figure: FigureKind, fill: FillKind) -> some View {
        let diamondConstant = RoundedRectangle(cornerRadius: 10)
            .frame(width: 35, height: 8)
        switch fill {
        case .filled:
            switch figure {
            case .oval:
                OvalView()
                    .foregroundColor(viewModel.hueToColor(from: card.hue))
            case .diamond:
                diamondConstant
                    .foregroundColor(viewModel.hueToColor(from: card.hue))
            case .circle:
                Circle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(viewModel.hueToColor(from: card.hue))
            }
        case .outlined:
            switch figure {
            case .oval:
                OvalView()
                    .stroke(viewModel.hueToColor(from: card.hue))
            case .diamond:
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(
                        viewModel.hueToColor(from: card.hue),
                        lineWidth: 2
                    )
                    .frame(width: 35, height: 8)
            case .circle:
                Circle()
                    .strokeBorder(
                        viewModel.hueToColor(from: card.hue),
                        lineWidth: 2
                    )
                    .frame(width: 15, height: 15)
            }
        case .striped:
            switch figure {
            case .oval:
                OvalView()
                    .stroke(viewModel.hueToColor(from: card.hue))
                    .overlay(
                        OvalView()
                            .fill(
                                viewModel.hueToColor(from: card.hue).opacity(0.3)
                            )
                    )
            case .diamond:
                diamondConstant
                    .foregroundColor(
                        viewModel.hueToColor(from: card.hue).opacity(0.3)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(
                                viewModel.hueToColor(from: card.hue),
                                lineWidth: 2
                            )
                    )
            case .circle:
                Circle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(
                        viewModel.hueToColor(from: card.hue).opacity(0.3)
                    )
                    .overlay(
                        Circle()
                            .strokeBorder(
                                viewModel.hueToColor(from: card.hue),
                                lineWidth: 2
                            )
                    )
            }
        }
    }
}
