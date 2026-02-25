//
//  AIPlayer3D.swift
//  Connect4D
//
//  Created by Andreas Pelczer on 25.02.26.
//


import Foundation

struct AIPlayer3D {
    
    static let maxDepth = 4
    
    static func bestMove(board: Board3D, player: Player) -> (x: Int, z: Int) {
        var bestScore = Int.min
        var bestMove = (x: 0, z: 0)
        
        for idx in stackOrder() {
            let coords = Board3D.coordinates(from: idx)
            guard board.canDrop(x: coords.x, z: coords.z) else { continue }
            
            var testBoard = board
            testBoard.dropPiece(x: coords.x, z: coords.z, player: player)
            
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
                bestMove = (coords.x, coords.z)
            }
        }
        
        return bestMove
    }
    
    // MARK: - Minimax
    
    private static func minimax(
        board: Board3D,
        depth: Int,
        alpha: Int,
        beta: Int,
        isMaximizing: Bool,
        aiPlayer: Player
    ) -> Int {
        let opponent = aiPlayer.toggled
        
        if hasWin(board: board, player: aiPlayer) { return 100_000 + depth }
        if hasWin(board: board, player: opponent) { return -100_000 - depth }
        if board.isFull { return 0 }
        if depth == 0 { return evaluate(board: board, aiPlayer: aiPlayer) }
        
        var alpha = alpha
        var beta = beta
        
        if isMaximizing {
            var maxScore = Int.min
            for idx in stackOrder() {
                let coords = Board3D.coordinates(from: idx)
                guard board.canDrop(x: coords.x, z: coords.z) else { continue }
                var testBoard = board
                testBoard.dropPiece(x: coords.x, z: coords.z, player: aiPlayer)
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
            for idx in stackOrder() {
                let coords = Board3D.coordinates(from: idx)
                guard board.canDrop(x: coords.x, z: coords.z) else { continue }
                var testBoard = board
                testBoard.dropPiece(x: coords.x, z: coords.z, player: opponent)
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
    
    // MARK: - Stangen-Reihenfolge (Mitte zuerst)
    
    private static func stackOrder() -> [Int] {
        // Mitte zuerst für besseres Pruning
        // Indizes: 0-15 für 4x4
        // Mitte: (1,1),(1,2),(2,1),(2,2) = Idx 5,6,9,10
        // Dann Rand-Mitte: (0,1),(0,2),(1,0),(2,0),(3,1),(3,2),(1,3),(2,3)
        // Dann Ecken: (0,0),(0,3),(3,0),(3,3)
        return [5, 6, 9, 10, 1, 2, 4, 8, 7, 11, 13, 14, 0, 3, 12, 15]
    }
    
    // MARK: - Gewinn-Check
    
    private static func hasWin(board: Board3D, player: Player) -> Bool {
        let target = CellState.occupied(player)
        
        for line in allWinLines {
            var count = 0
            for pos in line {
                if board.cellState(x: pos.0, y: pos.1, z: pos.2) == target {
                    count += 1
                } else { break }
            }
            if count == 4 { return true }
        }
        return false
    }
    
    // MARK: - Bewertung
    
    private static func evaluate(board: Board3D, aiPlayer: Player) -> Int {
        var score = 0
        let opponent = aiPlayer.toggled
        let aiState = CellState.occupied(aiPlayer)
        let oppState = CellState.occupied(opponent)
        
        // Zentrumsbonus
        let centerPositions = [(1,1), (1,2), (2,1), (2,2)]
        for (cx, cz) in centerPositions {
            let idx = Board3D.stackIndex(x: cx, z: cz)
            for cell in board.stacks[idx] {
                if cell == aiState { score += 3 }
                if cell == oppState { score -= 3 }
            }
        }
        
        // Alle 76 Gewinnlinien bewerten
        for line in allWinLines {
            var mine = 0
            var theirs = 0
            var empty = 0
            
            for pos in line {
                let cell = board.cellState(x: pos.0, y: pos.1, z: pos.2)
                if cell == aiState { mine += 1 }
                else if cell == oppState { theirs += 1 }
                else { empty += 1 }
            }
            
            // Nur reine Linien bewerten (keine gemischten)
            if theirs == 0 {
                if mine == 3 && empty == 1 { score += 50 }
                else if mine == 2 && empty == 2 { score += 10 }
                else if mine == 1 && empty == 3 { score += 1 }
            }
            if mine == 0 {
                if theirs == 3 && empty == 1 { score -= 40 }
                else if theirs == 2 && empty == 2 { score -= 8 }
            }
        }
        
        return score
    }
    
    // MARK: - Alle 76 Gewinnlinien vorberechnet
    
    private static let allWinLines: [[(Int, Int, Int)]] = {
        var lines = [[(Int, Int, Int)]]()
        let s = Board3D.size
        
        // Entlang X (16 Linien)
        for y in 0..<s {
            for z in 0..<s {
                lines.append((0..<s).map { ($0, y, z) })
            }
        }
        
        // Entlang Y (16 Linien)
        for x in 0..<s {
            for z in 0..<s {
                lines.append((0..<s).map { (x, $0, z) })
            }
        }
        
        // Entlang Z (16 Linien)
        for x in 0..<s {
            for y in 0..<s {
                lines.append((0..<s).map { (x, y, $0) })
            }
        }
        
        // XY-Diagonalen (8 Linien)
        for z in 0..<s {
            lines.append((0..<s).map { ($0, $0, z) })
            lines.append((0..<s).map { ($0, s - 1 - $0, z) })
        }
        
        // XZ-Diagonalen (8 Linien)
        for y in 0..<s {
            lines.append((0..<s).map { ($0, y, $0) })
            lines.append((0..<s).map { ($0, y, s - 1 - $0) })
        }
        
        // YZ-Diagonalen (8 Linien)
        for x in 0..<s {
            lines.append((0..<s).map { (x, $0, $0) })
            lines.append((0..<s).map { (x, $0, s - 1 - $0) })
        }
        
        // Raum-Diagonalen (4 Linien)
        lines.append((0..<s).map { ($0, $0, $0) })
        lines.append((0..<s).map { ($0, $0, s - 1 - $0) })
        lines.append((0..<s).map { ($0, s - 1 - $0, $0) })
        lines.append((0..<s).map { ($0, s - 1 - $0, s - 1 - $0) })
        
        return lines
    }()
}

