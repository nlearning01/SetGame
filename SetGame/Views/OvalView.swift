//
//  OvalView.swift
//  SetGame
//
//  Created by Сергей Захаров on 06.10.2025.
//

import SwiftUI

struct OvalView: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.width / 2, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height / 2))
        path.addLine(to: CGPoint(x: rect.width / 2, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height / 2))
        path.closeSubpath()
        return path
    }
}
