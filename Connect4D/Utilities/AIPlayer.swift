//
//  AIPlayer.swift
//  Connect4D
//
//  Created by Andreas Pelczer on 25.02.26.
//


import Foundation

struct AIPlayer {
    
    static let maxDepth = 5
    
    /// Gibt die beste Spalte für den KI-Spieler zurück
    static func bestMove(board: Board, player: Player) -> Int {
        var bestScore = Int.min
        var bestColumn = Board.columns / 2  // Fallback: Mitte
        
        for col in columnOrder() {
            guard board.canDrop(in: col) else { continue }
            
            var testBoard = board
            testBoard.dropPiece(in: col, player: player)
            
            let score = minimax(
                board: testBoard,
                depth: maxDepth - 1,
                alpha: Int.min,
                beta: Int.max,
                isMaximizing: false,
                aiPlayer: player
            )
            
            if score > bestScore {
                bestScore = score
                bestColumn = col
            }
        }
        
        return bestColumn
    }
    
    // MARK: - Minimax mit Alpha-Beta-Pruning
    
    private static func minimax(
        board: Board,
        depth: Int,
        alpha: Int,
        beta: Int,
        isMaximizing: Bool,
        aiPlayer: Player
    ) -> Int {
        let opponent = aiPlayer.toggled
        
        // Terminal-Check: Hat jemand gewonnen?
        if hasWin(board: board, player: aiPlayer) { return 100_000 + depth }
        if hasWin(board: board, player: opponent) { return -100_000 - depth }
        if board.isFull { return 0 }
        if depth == 0 { return evaluate(board: board, aiPlayer: aiPlayer) }
        
        var alpha = alpha
        var beta = beta
        
        if isMaximizing {
            var maxScore = Int.min
            for col in columnOrder() {
                guard board.canDrop(in: col) else { continue }
                var testBoard = board
                testBoard.dropPiece(in: col, player: aiPlayer)
                let score = minimax(
                    board: testBoard, depth: depth - 1,
                    alpha: alpha, beta: beta,
                    isMaximizing: false, aiPlayer: aiPlayer
                )
                maxScore = max(maxScore, score)
                alpha = max(alpha, score)
                if beta <= alpha { break }
            }
            return maxScore
        } else {
            var minScore = Int.max
            for col in columnOrder() {
                guard board.canDrop(in: col) else { continue }
                var testBoard = board
                testBoard.dropPiece(in: col, player: opponent)
                let score = minimax(
                    board: testBoard, depth: depth - 1,
                    alpha: alpha, beta: beta,
                    isMaximizing: true, aiPlayer: aiPlayer
                )
                minScore = min(minScore, score)
                beta = min(beta, score)
                if beta <= alpha { break }
            }
            return minScore
        }
    }
    
    // MARK: - Spaltenreihenfolge (Mitte zuerst = besseres Pruning)
    
    private static func columnOrder() -> [Int] {
        let mid = Board.columns / 2
        var order = [mid]
        for offset in 1...mid {
            if mid - offset >= 0 { order.append(mid - offset) }
            if mid + offset < Board.columns { order.append(mid + offset) }
        }
        return order
    }
    
    // MARK: - Schneller Gewinn-Check
    
    private static func hasWin(board: Board, player: Player) -> Bool {
        let target = CellState.occupied(player)
        
        for col in 0..<Board.columns {
            for row in 0..<board.grid[col].count {
                if board.cellState(column: col, row: row) != target { continue }
                
                let directions = [(1, 0), (0, 1), (1, 1), (1, -1)]
                for dir in directions {
                    var count = 1
                    for step in 1...3 {
                        let c = col + dir.0 * step
                        let r = row + dir.1 * step
                        if c >= 0, c < Board.columns, r >= 0,
                           board.cellState(column: c, row: r) == target {
                            count += 1
                        } else { break }
                    }
                    if count >= 4 { return true }
                }
            }
        }
        return false
    }
    
    // MARK: - Bewertungsfunktion
    
    private static func evaluate(board: Board, aiPlayer: Player) -> Int {
        var score = 0
        let opponent = aiPlayer.toggled
        
        // Zentrumsbonus
        let centerCol = Board.columns / 2
        for row in 0..<board.grid[centerCol].count {
            if board.cellState(column: centerCol, row: row) == .occupied(aiPlayer) {
                score += 3
            }
        }
        
        // Alle Fenster (4er-Gruppen) bewerten
        score += evaluateWindows(board: board, player: aiPlayer, opponent: opponent)
        
        return score
    }
    
    private static func evaluateWindows(board: Board, player: Player, opponent: Player) -> Int {
        var score = 0
        let directions = [(1, 0), (0, 1), (1, 1), (1, -1)]
        
        for col in 0..<Board.columns {
            for row in 0..<Board.rows {
                for dir in directions {
                    var mine = 0
                    var theirs = 0
                    var empty = 0
                    
                    for step in 0..<4 {
                        let c = col + dir.0 * step
                        let r = row + dir.1 * step
                        guard c >= 0, c < Board.columns, r >= 0, r < Board.rows else {
                            mine = 0; theirs = 0; empty = 0; break
                        }
                        let cell = board.cellState(column: c, row: r)
                        switch cell {
                        case .occupied(let p) where p == player: mine += 1
                        case .occupied: theirs += 1
                        case .empty: empty += 1
                        }
                    }
                    
                    if mine == 3 && empty == 1 { score += 50 }
                    else if mine == 2 && empty == 2 { score += 5 }
                    
                    if theirs == 3 && empty == 1 { score -= 40 }
                }
            }
        }
        
        return score
    }
}