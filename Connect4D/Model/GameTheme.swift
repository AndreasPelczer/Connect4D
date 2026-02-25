//
//  GameTheme.swift
//  Connect4D
//
//  Created by Andreas Pelczer on 25.02.26.
//


import SwiftUI

struct GameTheme: Equatable {
    let name: String
    let boardColor: Color
    let boardBorder: Color
    let emptyCell: Color
    let blackPiece: Color
    let blackPieceBorder: Color
    let whitePiece: Color
    let whitePieceBorder: Color
    let winHighlight: Color
    let backgroundColor: Color
    let buttonColor: Color
    let textColor: Color
}

extension GameTheme {
    
    static let wood = GameTheme(
        name: "Holz",
        boardColor: Color(red: 0.55, green: 0.35, blue: 0.17),
        boardBorder: Color(red: 0.40, green: 0.25, blue: 0.12),
        emptyCell: Color(red: 0.72, green: 0.53, blue: 0.30),
        blackPiece: Color(red: 0.15, green: 0.12, blue: 0.10),
        blackPieceBorder: Color(red: 0.35, green: 0.28, blue: 0.22),
        whitePiece: Color(red: 0.95, green: 0.90, blue: 0.80),
        whitePieceBorder: Color(red: 0.75, green: 0.70, blue: 0.60),
        winHighlight: Color(red: 0.85, green: 0.65, blue: 0.13),
        backgroundColor: Color(red: 0.96, green: 0.93, blue: 0.87),
        buttonColor: Color(red: 0.55, green: 0.35, blue: 0.17),
        textColor: Color(red: 0.25, green: 0.18, blue: 0.10)
    )
    
    static let industrial = GameTheme(
        name: "Industrial",
        boardColor: Color(red: 0.25, green: 0.27, blue: 0.30),
        boardBorder: Color(red: 0.18, green: 0.20, blue: 0.22),
        emptyCell: Color(red: 0.40, green: 0.42, blue: 0.45),
        blackPiece: Color(red: 0.08, green: 0.08, blue: 0.10),
        blackPieceBorder: Color(red: 0.28, green: 0.28, blue: 0.32),
        whitePiece: Color(red: 0.78, green: 0.80, blue: 0.82),
        whitePieceBorder: Color(red: 0.58, green: 0.60, blue: 0.62),
        winHighlight: Color(red: 1.0, green: 0.45, blue: 0.0),
        backgroundColor: Color(red: 0.14, green: 0.15, blue: 0.17),
        buttonColor: Color(red: 0.45, green: 0.47, blue: 0.50),
        textColor: Color(red: 0.85, green: 0.85, blue: 0.87)
    )
}
