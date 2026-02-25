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
        guard !animatingDrop else { return }  // Kein Doppelklick während Animation
        guard let position = board.dropPiece(in: column, player: currentPlayer) else { return }
        
        // Animation triggern
        lastDrop = position
        animatingDrop = true
        
        // Gewinnprüfung nach kurzer Verzögerung (Animation abwarten)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
            guard let self else { return }
            self.animatingDrop = false
            
            if let winPositions = WinChecker.checkWin(board: self.board, lastMove: position) {
                self.winningCells = winPositions
                self.gameState = .won(currentPlayer)
                return
            }
            
            if self.board.isFull {
                self.gameState = .draw
                return
            }
            
            self.gameState = .playing(currentPlayer.toggled)
        }
    }
    
    func reset() {
        startGame()
    }
}
