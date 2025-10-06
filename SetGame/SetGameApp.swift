//
//  SetGameApp.swift
//  SetGame
//
//  Created by Сергей Захаров on 06.10.2025.
//

import SwiftUI

@main
struct SetGameApp: App {
    var body: some Scene {
        WindowGroup {
            SetGameView(viewModel: SetGameViewModel())
        }
    }
}
