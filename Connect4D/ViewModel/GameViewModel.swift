//
//  GameViewModel.swift
//  Connect4D
//
//  Created by Andreas Pelczer on 25.02.26.
//

import Foundation

@Observable
class GameViewModel {
    
    private(set) var board = Board()
    private(set) var gameState: GameState = .idle
    private(set) var winningCells: [(column: Int, row: Int)]?
    private(set) var lastDrop: (column: Int, row: Int)?
    private(set) var animatingDrop = false
    var theme: GameTheme = .wood
    var singlePlayer = false        // NEU
    
    func toggleTheme() {
        theme = (theme == .wood) ? .industrial : .wood
    }
    
    func startGame() {
        board.reset()
        gameState = .playing(.black)
        winningCells = nil
        lastDrop = nil
        animatingDrop = false
    }
    
    func dropPiece(in column: Int) {
        guard case .playing(let currentPlayer) = gameState else { return }
        guard !animatingDrop else { return }
        guard let position = board.dropPiece(in: column, player: currentPlayer) else { return }
        
        lastDrop = position
        animatingDrop = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            SoundManager.shared.playDropSound()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
            guard let self else { return }
            self.animatingDrop = false
            
            if let winPositions = WinChecker.checkWin(board: self.board, lastMove: position) {
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
            
            // KI-Zug wenn Einzelspieler und Weiß dran
            if self.singlePlayer && nextPlayer == .white {
                self.performAIMove()
            }
        }
    }
    
    private func performAIMove() {
        // Kurze Verzögerung damit es natürlich wirkt
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            guard let self else { return }
            let column = AIPlayer.bestMove(board: self.board, player: .white)
            self.dropPiece(in: column)
        }
    }
    
    func reset() {
        startGame()
    }
}
