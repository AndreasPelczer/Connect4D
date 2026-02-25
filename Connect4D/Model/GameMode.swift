//
//  GameMode.swift
//  Connect4D
//
//  Created by Andreas Pelczer on 25.02.26.
//


import Foundation

enum GameMode: String, CaseIterable {
    case classic2D = "2D Klassisch"
    case mode3D = "3D (4×4×4)"
}

enum OpponentMode: String, CaseIterable {
    case twoPlayer = "2 Spieler"
    case ai = "vs KI"
}

struct GameConfig {
    var gameMode: GameMode = .classic2D
    var opponentMode: OpponentMode = .twoPlayer
}