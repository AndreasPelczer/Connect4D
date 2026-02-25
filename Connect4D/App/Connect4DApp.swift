//
//  Connect4DApp.swift
//  Connect4D
//
//  Created by Andreas Pelczer on 25.02.26.
//


import SwiftUI

@main
struct Connect4DApp: App {
    @State private var showGame = false
    @State private var config = GameConfig()
    @State private var theme: GameTheme = .wood
    
    var body: some Scene {
        WindowGroup {
            if showGame {
                if config.gameMode == .classic2D {
                    GameView(
                        config: config,
                        theme: theme,
                        onBack: { showGame = false }
                    )
                } else {
                    Game3DView(
                        config: config,
                        theme: theme,
                        onBack: { showGame = false }
                    )
                }
            } else {
                StartView(
                    config: $config,
                    theme: $theme,
                    onStart: { showGame = true }
                )
            }
        }
    }
}
