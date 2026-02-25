//
//  Board3D.swift
//  Connect4D
//
//  Created by Andreas Pelczer on 25.02.26.
//


import Foundation

struct Board3D {
    static let size = 4  // 4×4×4
    
    // grid[x][y][z] – x=Spalte, y=Reihe, z=Ebene
    // Aber wir nutzen Stangen: 16 Stangen (x,z), Steine stapeln sich auf y
    // Stange an Position (x,z), Stein fällt auf nächstes freies y
    private(set) var stacks: [[CellState]]  // 16 Stangen, je max 4 Steine
    
    init() {
        stacks = Array(
            repeating: [CellState](),
            count: Board3D.size * Board3D.size
        )
    }
    
    // MARK: - Stangen-Index aus (x, z)
    
    static func stackIndex(x: Int, z: Int) -> Int {
        z * size + x
    }
    
    static func coordinates(from stackIndex: Int) -> (x: Int, z: Int) {
        let x = stackIndex % size
        let z = stackIndex / size
        return (x, z)
    }
    
    // MARK: - Zugriff
    
    func cellState(x: Int, y: Int, z: Int) -> CellState {
        guard x >= 0, x < Board3D.size,
              y >= 0,
              z >= 0, z < Board3D.size else { return .empty }
        let idx = Board3D.stackIndex(x: x, z: z)
        guard y < stacks[idx].count else { return .empty }
        return stacks[idx][y]
    }
    
    func canDrop(x: Int, z: Int) -> Bool {
        guard x >= 0, x < Board3D.size,
              z >= 0, z < Board3D.size else { return false }
        let idx = Board3D.stackIndex(x: x, z: z)
        return stacks[idx].count < Board3D.size
    }
    
    @discardableResult
    mutating func dropPiece(x: Int, z: Int, player: Player) -> (x: Int, y: Int, z: Int)? {
        guard canDrop(x: x, z: z) else { return nil }
        let idx = Board3D.stackIndex(x: x, z: z)
        let y = stacks[idx].count
        stacks[idx].append(.occupied(player))
        return (x, y, z)
    }
    
    var isFull: Bool {
        stacks.allSatisfy { $0.count >= Board3D.size }
    }
    
    mutating func reset() {
        stacks = Array(
            repeating: [CellState](),
            count: Board3D.size * Board3D.size
        )
    }
}