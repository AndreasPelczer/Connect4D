//
//  GameState.swift
//  Connect4D
//
//  Created by Andreas Pelczer on 25.02.26.
//


import Foundation

enum GameState: Equatable {
    case idle
    case playing(Player)
    case won(Player)
    case draw
}