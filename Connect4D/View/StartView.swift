//
//  StartView.swift
//  Connect4D
//
//  Created by Andreas Pelczer on 25.02.26.
//


import SwiftUI

struct StartView: View {
    @Binding var config: GameConfig
    @Binding var theme: GameTheme
    let onStart: () -> Void
    
    var body: some View {
        ZStack {
            theme.backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Titel
                VStack(spacing: 8) {
                    Text("Connect")
                        .font(.system(size: 42, weight: .light))
                        .foregroundColor(theme.textColor)
                    Text("4D")
                        .font(.system(size: 64, weight: .black))
                        .foregroundColor(theme.winHighlight)
                }
                
                // Mini-Vorschau: 4 Steine diagonal
                previewBoard
                
                Spacer()
                
                // Spielmodus
                VStack(alignment: .leading, spacing: 8) {
                    Text("SPIELMODUS")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(theme.textColor.opacity(0.6))
                    
                    HStack(spacing: 4) {
                        ForEach(GameMode.allCases, id: \.self) { mode in
                            optionButton(
                                title: mode.rawValue,
                                isSelected: config.gameMode == mode,
                                isEnabled: mode == .classic2D  // 3D noch nicht verfügbar
                            ) {
                                config.gameMode = mode
                            }
                        }
                    }
                }
                .padding(.horizontal, 32)
                
                // Gegner
                VStack(alignment: .leading, spacing: 8) {
                    Text("GEGNER")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(theme.textColor.opacity(0.6))
                    
                    HStack(spacing: 4) {
                        ForEach(OpponentMode.allCases, id: \.self) { mode in
                            optionButton(
                                title: mode.rawValue,
                                isSelected: config.opponentMode == mode,
                                isEnabled: true
                            ) {
                                config.opponentMode = mode
                            }
                        }
                    }
                }
                .padding(.horizontal, 32)
                
                Spacer()
                
                // Start Button
                Button(action: onStart) {
                    Text("Spiel starten")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(theme.winHighlight)
                        )
                }
                .padding(.horizontal, 40)
                
                // Theme Toggle
                Button(action: {
                    theme = (theme == .wood) ? .industrial : .wood
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: theme == .wood ? "hammer.fill" : "leaf.fill")
                        Text(theme == .wood ? "Industrial" : "Holz")
                    }
                    .font(.subheadline)
                    .foregroundColor(theme.textColor.opacity(0.7))
                }
                .padding(.bottom, 32)
            }
        }
    }
    
    // MARK: - Option Button
    
    private func optionButton(
        title: String,
        isSelected: Bool,
        isEnabled: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: {
            if isEnabled { action() }
        }) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundColor(
                    !isEnabled ? theme.textColor.opacity(0.3) :
                    isSelected ? .white : theme.textColor
                )
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            !isEnabled ? theme.boardColor.opacity(0.15) :
                            isSelected ? theme.buttonColor : theme.boardColor.opacity(0.3)
                        )
                )
        }
        .disabled(!isEnabled)
    }
    
    // MARK: - Mini Preview
    
    private var previewBoard: some View {
        let size: CGFloat = 28
        let spacing: CGFloat = 4
        
        return ZStack {
            // Brett-Hintergrund
            RoundedRectangle(cornerRadius: 8)
                .fill(theme.boardColor)
                .frame(
                    width: size * 4 + spacing * 5,
                    height: size * 4 + spacing * 5
                )
            
            // 4×4 Grid mit diagonaler Gewinnlinie
            VStack(spacing: spacing) {
                ForEach((0..<4).reversed(), id: \.self) { row in
                    HStack(spacing: spacing) {
                        ForEach(0..<4, id: \.self) { col in
                            Circle()
                                .fill(previewColor(col: col, row: row))
                                .frame(width: size, height: size)
                                .overlay(
                                    Circle()
                                        .stroke(
                                            col == row ? theme.winHighlight : Color.clear,
                                            lineWidth: col == row ? 2 : 0
                                        )
                                )
                        }
                    }
                }
            }
        }
    }
    
    private func previewColor(col: Int, row: Int) -> Color {
        if col == row {
            return theme.blackPiece  // Diagonale Gewinnlinie
        }
        // Einige "zufällige" Steine
        let whitePositions = [(0, 1), (1, 0), (2, 0), (1, 2)]
        if whitePositions.contains(where: { $0.0 == col && $0.1 == row }) {
            return theme.whitePiece
        }
        return theme.backgroundColor.opacity(0.5)
    }
}