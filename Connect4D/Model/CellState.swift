//
//  CellState.swift
//  Connect4D
//
//  Created by Andreas Pelczer on 25.02.26.
//


import Foundation

enum CellState: Equatable {
    case empty
    case occupied(Player)
}