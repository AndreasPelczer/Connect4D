//
//  Player.swift
//  Connect4D
//
//  Created by Andreas Pelczer on 25.02.26.
//


import Foundation

enum Player {
    case black
    case white
    
    var toggled: Player {
        switch self {
        case .black: return .white
        case .white: return .black
        }
    }
    
    var displayName: String {
        switch self {
        case .black: return "Schwarz"
        case .white: return "Weiß"
        }
    }
}