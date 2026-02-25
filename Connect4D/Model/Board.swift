//
//  Board.swift
//  Connect4D
//
//  Created by Andreas Pelczer on 25.02.26.
//


import Foundation

struct Board {
    static let columns = 7
    static let rows = 6
    
    private(set) var grid: [[CellState]]
    
    init() {
        grid = Array(
            repeating: [CellState](),
            count: Board.columns
        )
    }
    
    func cellState(column: Int, row: Int) -> CellState {
        guard column >= 0, column < Board.columns,
              row >= 0, row < grid[column].count else {
            return .empty
        }
        return grid[column][row]
    }
    
    func canDrop(in column: Int) -> Bool {
        guard column >= 0, column < Board.columns else { return false }
        return grid[column].count < Board.rows
    }
    
    @discardableResult
    mutating func dropPiece(in column: Int, player: Player) -> (column: Int, row: Int)? {
        guard canDrop(in: column) else { return nil }
        let row = grid[column].count
        grid[column].append(.occupied(player))
        return (column, row)
    }
    
    var isFull: Bool {
        grid.allSatisfy { $0.count >= Board.rows }
    }
    
    mutating func reset() {
        grid = Array(
            repeating: [CellState](),
            count: Board.columns
        )
    }
}