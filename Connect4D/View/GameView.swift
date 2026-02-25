//
//  GameView.swift
//  Connect4D
//
//  Created by Andreas Pelczer on 25.02.26.
//


import SwiftUI

struct GameView: View {
    @State private var viewModel = GameViewModel()
    let config: GameConfig
    let theme: GameTheme
    let onBack: () -> Void
    
    var body: some View {
        ZStack {
            theme.backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Zurück-Button
                HStack {
                    Button(action: onBack) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Menü")
                        }
                        .font(.subheadline)
                        .foregroundColor(theme.textColor.opacity(0.7))
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                Spacer()
                
                HeaderView(
                    gameState: viewModel.gameState,
                    theme: theme
                )
                
                BoardView(
                    board: viewModel.board,
                    winningCells: viewModel.winningCells,
                    theme: theme,
                    lastDrop: viewModel.lastDrop,
                    animatingDrop: viewModel.animatingDrop,
                    onColumnTap: { column in
                        viewModel.dropPiece(in: column)
                    }
                )
                .padding(.horizontal)
                
                Button(action: {
                    viewModel.startGame()
                }) {
                    Text("Neues Spiel")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(theme.buttonColor)
                        )
                }
                
                Spacer()
            }
        }
        .onAppear {
            viewModel.singlePlayer = (config.opponentMode == .ai)
            viewModel.theme = theme
            viewModel.startGame()
        }
    }
}
