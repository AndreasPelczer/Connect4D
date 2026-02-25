//
//  WinChecker.swift
//  Connect4D
//
//  Created by Andreas Pelczer on 25.02.26.
//


import Foundation

struct WinChecker {
    
    /// Prüft ob der zuletzt gesetzte Stein eine Viererreihe erzeugt hat.
    /// Gibt die vier Gewinnpositionen zurück, oder nil.
    static func checkWin(
        board: Board,
        lastMove: (column: Int, row: Int)
    ) -> [(column: Int, row: Int)]? {
        
        let col = lastMove.column
        let row = lastMove.row
        let state = board.cellState(column: col, row: row)
        
        // Nur belegte Felder prüfen
        guard case .occupied = state else { return nil }
        
        // Die vier Achsen: (Spaltenrichtung, Reihenrichtung)
        let directions: [(Int, Int)] = [
            (1, 0),   // horizontal
            (0, 1),   // vertikal
            (1, 1),   // diagonal aufsteigend
            (1, -1)   // diagonal absteigend
        ]
        
        for direction in directions {
            var positions = [(column: Int, row: Int)]()
            positions.append((col, row))
            
            // In positive Richtung zählen
            positions.append(
                contentsOf: collect(
                    board: board,
                    from: (col, row),
                    direction: direction,
                    matching: state
                )
            )
            
            // In negative Richtung zählen (Vektor umkehren)
            positions.append(
                contentsOf: collect(
                    board: board,
                    from: (col, row),
                    direction: (-direction.0, -direction.1),
                    matching: state
                )
            )
            
            if positions.count >= 4 {
                return Array(positions.prefix(4))
            }
        }
        
        return nil
    }
    
    /// Sammelt aufeinanderfolgende gleichfarbige Positionen in einer Richtung.
    private static func collect(
        board: Board,
        from start: (Int, Int),
        direction: (Int, Int),
        matching state: CellState
    ) -> [(column: Int, row: Int)] {
        
        var results = [(column: Int, row: Int)]()
        var col = start.0 + direction.0
        var row = start.1 + direction.1
        
        while col >= 0, col < Board.columns,
              row >= 0, row < Board.rows,
              board.cellState(column: col, row: row) == state {
            results.append((col, row))
            col += direction.0
            row += direction.1
        }
        
        return results
    }
}