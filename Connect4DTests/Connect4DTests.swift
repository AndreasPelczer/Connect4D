//
//  Connect4DTests.swift
//  Connect4DTests
//
//  Created by Andreas Pelczer on 25.02.26.
//

import Testing
@testable import Connect4D

// MARK: - Board Tests

struct BoardTests {

    @Test func newBoardIsEmpty() {
        let board = Board()
        for col in 0..<Board.columns {
            #expect(board.grid[col].isEmpty)
        }
        #expect(!board.isFull)
    }

    @Test func dropPieceReturnsCorrectPosition() {
        var board = Board()
        let result = board.dropPiece(in: 3, player: .black)
        #expect(result?.column == 3)
        #expect(result?.row == 0)
    }

    @Test func dropPieceStacksCorrectly() {
        var board = Board()
        board.dropPiece(in: 2, player: .black)
        board.dropPiece(in: 2, player: .white)
        let result = board.dropPiece(in: 2, player: .black)
        #expect(result?.row == 2)
        #expect(board.cellState(column: 2, row: 0) == .occupied(.black))
        #expect(board.cellState(column: 2, row: 1) == .occupied(.white))
        #expect(board.cellState(column: 2, row: 2) == .occupied(.black))
    }

    @Test func cannotDropInFullColumn() {
        var board = Board()
        for _ in 0..<Board.rows {
            board.dropPiece(in: 0, player: .black)
        }
        #expect(!board.canDrop(in: 0))
        #expect(board.dropPiece(in: 0, player: .white) == nil)
    }

    @Test func cannotDropOutOfBounds() {
        let board = Board()
        #expect(!board.canDrop(in: -1))
        #expect(!board.canDrop(in: Board.columns))
    }

    @Test func boardIsFull() {
        var board = Board()
        for col in 0..<Board.columns {
            for _ in 0..<Board.rows {
                board.dropPiece(in: col, player: .black)
            }
        }
        #expect(board.isFull)
    }

    @Test func resetClearsBoard() {
        var board = Board()
        board.dropPiece(in: 0, player: .black)
        board.dropPiece(in: 3, player: .white)
        board.reset()
        for col in 0..<Board.columns {
            #expect(board.grid[col].isEmpty)
        }
    }

    @Test func cellStateOutOfBoundsReturnsEmpty() {
        let board = Board()
        #expect(board.cellState(column: -1, row: 0) == .empty)
        #expect(board.cellState(column: 0, row: 99) == .empty)
    }
}

// MARK: - Board3D Tests

struct Board3DTests {

    @Test func newBoard3DIsEmpty() {
        let board = Board3D()
        #expect(!board.isFull)
        for idx in 0..<(Board3D.size * Board3D.size) {
            #expect(board.stacks[idx].isEmpty)
        }
    }

    @Test func dropPiece3DReturnsCorrectPosition() {
        var board = Board3D()
        let result = board.dropPiece(x: 1, z: 2, player: .black)
        #expect(result?.x == 1)
        #expect(result?.y == 0)
        #expect(result?.z == 2)
    }

    @Test func dropPiece3DStacks() {
        var board = Board3D()
        board.dropPiece(x: 0, z: 0, player: .black)
        board.dropPiece(x: 0, z: 0, player: .white)
        let result = board.dropPiece(x: 0, z: 0, player: .black)
        #expect(result?.y == 2)
    }

    @Test func cannotDropOnFullStack3D() {
        var board = Board3D()
        for _ in 0..<Board3D.size {
            board.dropPiece(x: 0, z: 0, player: .black)
        }
        #expect(!board.canDrop(x: 0, z: 0))
    }

    @Test func stackIndexCoordinateRoundtrip() {
        for x in 0..<Board3D.size {
            for z in 0..<Board3D.size {
                let idx = Board3D.stackIndex(x: x, z: z)
                let coords = Board3D.coordinates(from: idx)
                #expect(coords.x == x)
                #expect(coords.z == z)
            }
        }
    }
}

// MARK: - WinChecker Tests

struct WinCheckerTests {

    @Test func horizontalWin() {
        var board = Board()
        for col in 0..<4 {
            board.dropPiece(in: col, player: .black)
        }
        let result = WinChecker.checkWin(board: board, lastMove: (column: 3, row: 0))
        #expect(result != nil)
        #expect(result?.count == 4)
    }

    @Test func verticalWin() {
        var board = Board()
        for _ in 0..<4 {
            board.dropPiece(in: 0, player: .black)
        }
        let result = WinChecker.checkWin(board: board, lastMove: (column: 0, row: 3))
        #expect(result != nil)
        #expect(result?.count == 4)
    }

    @Test func diagonalWin() {
        var board = Board()
        // Baue eine aufsteigende Diagonale
        // Spalte 0: Schwarz
        board.dropPiece(in: 0, player: .black)
        // Spalte 1: Weiß, Schwarz
        board.dropPiece(in: 1, player: .white)
        board.dropPiece(in: 1, player: .black)
        // Spalte 2: Weiß, Weiß, Schwarz
        board.dropPiece(in: 2, player: .white)
        board.dropPiece(in: 2, player: .white)
        board.dropPiece(in: 2, player: .black)
        // Spalte 3: Weiß, Weiß, Weiß, Schwarz
        board.dropPiece(in: 3, player: .white)
        board.dropPiece(in: 3, player: .white)
        board.dropPiece(in: 3, player: .white)
        board.dropPiece(in: 3, player: .black)

        let result = WinChecker.checkWin(board: board, lastMove: (column: 3, row: 3))
        #expect(result != nil)
        #expect(result?.count == 4)
    }

    @Test func noWinOnThreeInARow() {
        var board = Board()
        for col in 0..<3 {
            board.dropPiece(in: col, player: .black)
        }
        let result = WinChecker.checkWin(board: board, lastMove: (column: 2, row: 0))
        #expect(result == nil)
    }

    @Test func draw() {
        var board = Board()
        // Fülle das Brett ohne Gewinner (alternierend)
        for col in 0..<Board.columns {
            for row in 0..<Board.rows {
                let player: Player = ((col + row) % 2 == 0) ? .black : .white
                board.dropPiece(in: col, player: player)
            }
        }
        #expect(board.isFull)
    }
}

// MARK: - WinChecker3D Tests

struct WinChecker3DTests {

    @Test func verticalWin3D() {
        var board = Board3D()
        for _ in 0..<4 {
            board.dropPiece(x: 0, z: 0, player: .black)
        }
        let result = WinChecker3D.checkWin(board: board, lastMove: (x: 0, y: 3, z: 0))
        #expect(result != nil)
        #expect(result?.count == 4)
    }

    @Test func horizontalXWin3D() {
        var board = Board3D()
        for x in 0..<4 {
            board.dropPiece(x: x, z: 0, player: .black)
        }
        let result = WinChecker3D.checkWin(board: board, lastMove: (x: 3, y: 0, z: 0))
        #expect(result != nil)
        #expect(result?.count == 4)
    }

    @Test func horizontalZWin3D() {
        var board = Board3D()
        for z in 0..<4 {
            board.dropPiece(x: 0, z: z, player: .white)
        }
        let result = WinChecker3D.checkWin(board: board, lastMove: (x: 0, y: 0, z: 3))
        #expect(result != nil)
        #expect(result?.count == 4)
    }

    @Test func noWin3DWithThree() {
        var board = Board3D()
        for x in 0..<3 {
            board.dropPiece(x: x, z: 0, player: .black)
        }
        let result = WinChecker3D.checkWin(board: board, lastMove: (x: 2, y: 0, z: 0))
        #expect(result == nil)
    }
}

// MARK: - AIPlayer Tests

struct AIPlayerTests {

    @Test func aiBlocksImmediateWin() {
        var board = Board()
        // Schwarz hat 3 in einer Reihe: Spalte 0, 1, 2
        board.dropPiece(in: 0, player: .black)
        board.dropPiece(in: 1, player: .black)
        board.dropPiece(in: 2, player: .black)

        // KI (Weiß) muss Spalte 3 blocken
        let move = AIPlayer.bestMove(board: board, player: .white)
        #expect(move == 3)
    }

    @Test func aiTakesImmediateWin() {
        var board = Board()
        // Weiß hat 3 in einer Reihe: Spalte 0, 1, 2
        board.dropPiece(in: 0, player: .white)
        board.dropPiece(in: 1, player: .white)
        board.dropPiece(in: 2, player: .white)
        // Etwas Schwarz daneben
        board.dropPiece(in: 5, player: .black)
        board.dropPiece(in: 6, player: .black)

        // KI (Weiß) sollte Spalte 3 nehmen für den Gewinn
        let move = AIPlayer.bestMove(board: board, player: .white)
        #expect(move == 3)
    }

    @Test func aiReturnsValidColumn() {
        let board = Board()
        let move = AIPlayer.bestMove(board: board, player: .white)
        #expect(move >= 0 && move < Board.columns)
    }
}

// MARK: - Player Tests

struct PlayerTests {

    @Test func playerToggle() {
        #expect(Player.black.toggled == .white)
        #expect(Player.white.toggled == .black)
    }

    @Test func playerDisplayName() {
        #expect(Player.black.displayName == "Schwarz")
        #expect(Player.white.displayName == "Weiß")
    }
}

// MARK: - GameState Tests

struct GameStateTests {

    @Test func gameStateEquality() {
        #expect(GameState.idle == GameState.idle)
        #expect(GameState.draw == GameState.draw)
        #expect(GameState.won(.black) == GameState.won(.black))
        #expect(GameState.won(.black) != GameState.won(.white))
        #expect(GameState.playing(.black) == GameState.playing(.black))
        #expect(GameState.playing(.black) != GameState.draw)
    }
}
