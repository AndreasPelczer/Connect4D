//
//  GameViewModel3D.swift
//  Connect4D
//
//  Created by Andreas Pelczer on 25.02.26.
//


import Foundation

@Observable
class GameViewModel3D {
    
    private(set) var board = Board3D()
    private(set) var gameState: GameState = .idle
    private(set) var winningCells: [(x: Int, y: Int, z: Int)]?
    private(set) var lastDrop: (x: Int, y: Int, z: Int)?
    private(set) var animatingDrop = false
    var singlePlayer = false
    
    func startGame() {
        board.reset()
        gameState = .playing(.black)
        winningCells = nil
        lastDrop = nil
        animatingDrop = false
    }
    
    func dropPiece(x: Int, z: Int) {
        guard case .playing(let currentPlayer) = gameState else { return }
        guard !animatingDrop else { return }
        guard let position = board.dropPiece(x: x, z: z, player: currentPlayer) else { return }
        
        lastDrop = position
        animatingDrop = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            SoundManager.shared.playDropSound()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
            guard let self else { return }
            self.animatingDrop = false
            
            if let winPositions = WinChecker3D.checkWin(board: self.board, lastMove: position) {
                self.winningCells = winPositions
                self.gameState = .won(currentPlayer)
                SoundManager.shared.playWinSound()
                return
            }
            
            if self.board.isFull {
                self.gameState = .draw
                return
            }
            
            let nextPlayer = currentPlayer.toggled
            self.gameState = .playing(nextPlayer)
            
            if self.singlePlayer && nextPlayer == .white {
                self.performAIMove()
            }
        }
    }
    
    private func performAIMove() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            guard let self else { return }
            // Einfache KI: zufällige Spalte (Minimax für 3D kommt später)
            let available = (0..<(Board3D.size * Board3D.size)).filter { idx in
                let coords = Board3D.coordinates(from: idx)
                return self.board.canDrop(x: coords.x, z: coords.z)
            }
            guard let randomIdx = available.randomElement() else { return }
            let coords = Board3D.coordinates(from: randomIdx)
            self.dropPiece(x: coords.x, z: coords.z)
        }
    }
    
    func reset() {
        startGame()
    }
}