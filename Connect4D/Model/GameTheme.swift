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
    let whitePiece: Color
    let winHighlight: Color
    let backgroundColor: Color
    let buttonColor: Color
    let textColor: Color
}

extension GameTheme {
    
    static let wood = GameTheme(
        name: "Holz",
        boardColor: Color(red: 0.55, green: 0.35, blue: 0.17),      // warmes Nussbaum
        boardBorder: Color(red: 0.40, green: 0.25, blue: 0.12),      // dunklerer Rand
        emptyCell: Color(red: 0.72, green: 0.53, blue: 0.30),        // helles Holz (Löcher)
        blackPiece: Color(red: 0.15, green: 0.12, blue: 0.10),       // fast schwarz, leicht warm
        whitePiece: Color(red: 0.95, green: 0.90, blue: 0.80),       // cremeweiß
        winHighlight: Color(red: 0.85, green: 0.65, blue: 0.13),     // Gold
        backgroundColor: Color(red: 0.96, green: 0.93, blue: 0.87),  // warmer Hintergrund
        buttonColor: Color(red: 0.55, green: 0.35, blue: 0.17),
        textColor: Color(red: 0.25, green: 0.18, blue: 0.10)
    )
    
    static let industrial = GameTheme(
        name: "Industrial",
        boardColor: Color(red: 0.25, green: 0.27, blue: 0.30),       // Stahl dunkel
        boardBorder: Color(red: 0.18, green: 0.20, blue: 0.22),
        emptyCell: Color(red: 0.40, green: 0.42, blue: 0.45),        // Metall mittel
        blackPiece: Color(red: 0.08, green: 0.08, blue: 0.10),       // Eisen schwarz
        whitePiece: Color(red: 0.78, green: 0.80, blue: 0.82),       // gebürstetes Aluminium
        winHighlight: Color(red: 1.0, green: 0.45, blue: 0.0),       // Warnfarbe Orange
        backgroundColor: Color(red: 0.14, green: 0.15, blue: 0.17),  // dunkler Hintergrund
        buttonColor: Color(red: 0.45, green: 0.47, blue: 0.50),
        textColor: Color(red: 0.85, green: 0.85, blue: 0.87)
    )
}