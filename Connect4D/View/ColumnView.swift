//
//  ColumnView.swift
//  Connect4D
//
//  Created by Andreas Pelczer on 25.02.26.
//

import SwiftUI

struct ColumnView: View {
    let columnIndex: Int
    let cells: [CellState]
    let winningCells: [(column: Int, row: Int)]?
    let theme: GameTheme
    let lastDrop: (column: Int, row: Int)?
    let animatingDrop: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 4) {
            ForEach((0..<Board.rows).reversed(), id: \.self) { row in
                CellView(
                    state: row < cells.count ? cells[row] : .empty,
                    isWinningCell: isWinning(row: row),
                    theme: theme
                )
                .aspectRatio(1, contentMode: .fit)
                .modifier(
                    DropAnimationModifier(
                        shouldAnimate: shouldAnimate(row: row),
                        rowsToFall: rowsToFall(for: row)
                    )
                )
            }
        }
        .onTapGesture {
            onTap()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Spalte \(columnIndex + 1)")
        .accessibilityHint(columnHint)
        .accessibilityAddTraits(.isButton)
    }

    private var columnHint: String {
        let filled = cells.count
        if filled >= Board.rows {
            return "Voll"
        }
        return "Tippen um Stein einzuwerfen, \(filled) von \(Board.rows) belegt"
    }
    
    private func shouldAnimate(row: Int) -> Bool {
        guard animatingDrop,
              let lastDrop,
              lastDrop.column == columnIndex,
              lastDrop.row == row else { return false }
        return true
    }
    
    private func rowsToFall(for row: Int) -> Int {
        Board.rows - row
    }
    
    private func isWinning(row: Int) -> Bool {
        guard let winningCells else { return false }
        return winningCells.contains { $0.column == columnIndex && $0.row == row }
    }
}
