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
        Circle()
            .fill(fillColor)
            .overlay(
                Circle()
                    .stroke(isWinningCell ? theme.winHighlight : Color.clear, lineWidth: 3)
            )
            .shadow(
                color: state != .empty ? .black.opacity(0.3) : .clear,
                radius: 2, x: 0, y: 2
            )
    }
    
    private var fillColor: Color {
        switch state {
        case .empty:
            return theme.emptyCell
        case .occupied(let player):
            switch player {
            case .black: return theme.blackPiece
            case .white: return theme.whitePiece
            }
        }
    }
}
