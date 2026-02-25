//
//  CellView.swift
//  Connect4D
//
//  Created by Andreas Pelczer on 25.02.26.
//


import SwiftUI

struct CellView: View {
    let state: CellState
    let isWinningCell: Bool
    let theme: GameTheme
    
    var body: some View {
        switch state {
        case .empty:
            emptyCell
        case .occupied(let player):
            pieceView(for: player)
        }
    }
    
    // MARK: - Leeres Feld (halbtransparent)
    
    private var emptyCell: some View {
        Circle()
            .fill(theme.backgroundColor.opacity(0.5))
            .overlay(
                Circle()
                    .stroke(theme.boardColor.opacity(0.5), lineWidth: 1)
            )
    }
    
    // MARK: - Spielstein mit 3D-Effekt
    
    private func pieceView(for player: Player) -> some View {
        let baseColor = player == .black ? theme.blackPiece : theme.whitePiece
        let borderColor = player == .black ? theme.blackPieceBorder : theme.whitePieceBorder
        
        return Circle()
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [
                        baseColor.opacity(1.0),
                        baseColor,
                        borderColor
                    ]),
                    center: .init(x: 0.35, y: 0.35),
                    startRadius: 0,
                    endRadius: 50
                )
            )
            .overlay(
                // Lichtreflex oben links
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(player == .black ? 0.15 : 0.4),
                                Color.clear
                            ]),
                            center: .init(x: 0.3, y: 0.3),
                            startRadius: 0,
                            endRadius: 30
                        )
                    )
            )
            .overlay(
                // Rand
                Circle()
                    .stroke(borderColor, lineWidth: 2)
            )
            .overlay(
                // Gewinn-Highlight
                Circle()
                    .stroke(isWinningCell ? theme.winHighlight : Color.clear, lineWidth: 3)
            )
            .shadow(color: .black.opacity(0.4), radius: 3, x: 1, y: 3)
    }
}
