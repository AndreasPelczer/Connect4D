//
//  WinChecker3D.swift
//  Connect4D
//
//  Created by Andreas Pelczer on 25.02.26.
//


import Foundation

struct WinChecker3D {
    
    // 13 Achsen in 3D (jede Achse hat zwei Richtungen)
    // 3 Achsen-parallel: entlang x, y, z
    // 6 Flächen-Diagonalen: xy, xz, yz (je 2)
    // 4 Raum-Diagonalen
    private static let directions: [(Int, Int, Int)] = [
        // Achsen-parallel
        (1, 0, 0),   // entlang x
        (0, 1, 0),   // entlang y (vertikal auf Stange)
        (0, 0, 1),   // entlang z
        // Flächen-Diagonalen (xy-Ebene)
        (1, 1, 0),
        (1, -1, 0),
        // Flächen-Diagonalen (xz-Ebene)
        (1, 0, 1),
        (1, 0, -1),
        // Flächen-Diagonalen (yz-Ebene)
        (0, 1, 1),
        (0, 1, -1),
        // Raum-Diagonalen
        (1, 1, 1),
        (1, 1, -1),
        (1, -1, 1),
        (1, -1, -1)
    ]
    
    static func checkWin(
        board: Board3D,
        lastMove: (x: Int, y: Int, z: Int)
    ) -> [(x: Int, y: Int, z: Int)]? {
        
        let state = board.cellState(x: lastMove.x, y: lastMove.y, z: lastMove.z)
        guard case .occupied = state else { return nil }
        
        for dir in directions {
            var positions = [(x: Int, y: Int, z: Int)]()
            positions.append(lastMove)
            
            // Positive Richtung
            positions.append(contentsOf: collect(
                board: board, from: lastMove,
                direction: dir, matching: state
            ))
            
            // Negative Richtung
            positions.append(contentsOf: collect(
                board: board, from: lastMove,
                direction: (-dir.0, -dir.1, -dir.2),
                matching: state
            ))
            
            if positions.count >= 4 {
                return Array(positions.prefix(4))
            }
        }
        
        return nil
    }
    
    private static func collect(
        board: Board3D,
        from start: (x: Int, y: Int, z: Int),
        direction: (Int, Int, Int),
        matching state: CellState
    ) -> [(x: Int, y: Int, z: Int)] {
        
        var results = [(x: Int, y: Int, z: Int)]()
        var x = start.x + direction.0
        var y = start.y + direction.1
        var z = start.z + direction.2
        
        while x >= 0, x < Board3D.size,
              y >= 0, y < Board3D.size,
              z >= 0, z < Board3D.size,
              board.cellState(x: x, y: y, z: z) == state {
            results.append((x, y, z))
            x += direction.0
            y += direction.1
            z += direction.2
        }
        
        return results
    }
}