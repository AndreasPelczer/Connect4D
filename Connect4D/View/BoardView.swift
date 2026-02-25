//
//  BoardView.swift
//  Connect4D
//
//  Created by Andreas Pelczer on 25.02.26.
//

import SwiftUI

struct BoardView: View {
    let board: Board
    let winningCells: [(column: Int, row: Int)]?
    let theme: GameTheme
    let lastDrop: (column: Int, row: Int)?
    let animatingDrop: Bool
    let onColumnTap: (Int) -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<Board.columns, id: \.self) { col in
                ColumnView(
                    columnIndex: col,
                    cells: board.grid[col],
                    winningCells: winningCells,
                    theme: theme,
                    lastDrop: lastDrop,
                    animatingDrop: animatingDrop,
                    onTap: { onColumnTap(col) }
                )
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(theme.boardColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(theme.boardBorder, lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.4), radius: 6, x: 0, y: 4)
        )
    }
}
