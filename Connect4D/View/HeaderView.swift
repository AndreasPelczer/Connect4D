//
//  HeaderView.swift
//  Connect4D
//
//  Created by Andreas Pelczer on 25.02.26.
//


import SwiftUI

struct HeaderView: View {
    let gameState: GameState
    let theme: GameTheme
    
    var body: some View {
        HStack(spacing: 12) {
            if let playerColor = indicatorColor {
                Circle()
                    .fill(playerColor)
                    .frame(width: 24, height: 24)
                    .overlay(
                        Circle().stroke(theme.textColor.opacity(0.3), lineWidth: 1)
                    )
            }
            
            Text(statusText)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(theme.textColor)
        }
        .padding()
        .accessibilityElement(children: .combine)
        .accessibilityLabel(statusText)
        .accessibilityAddTraits(.updatesFrequently)
    }
    
    private var statusText: String {
        switch gameState {
        case .idle:
            return "Neues Spiel starten"
        case .playing(let player):
            return "\(player.displayName) ist am Zug"
        case .won(let player):
            return "\(player.displayName) gewinnt!"
        case .draw:
            return "Unentschieden!"
        }
    }
    
    private var indicatorColor: Color? {
        switch gameState {
        case .playing(let player), .won(let player):
            return player == .black ? theme.blackPiece : theme.whitePiece
        default:
            return nil
        }
    }
}
