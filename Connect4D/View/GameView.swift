//
//  GameView.swift
//  Connect4D
//
//  Created by Andreas Pelczer on 25.02.26.
//


import SwiftUI

struct GameView: View {
    @State private var viewModel = GameViewModel()
    
    var body: some View {
        ZStack {
            viewModel.theme.backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer()
                
                HeaderView(
                    gameState: viewModel.gameState,
                    theme: viewModel.theme
                )
                
                BoardView(
                    board: viewModel.board,
                    winningCells: viewModel.winningCells,
                    theme: viewModel.theme,
                    lastDrop: viewModel.lastDrop,
                    animatingDrop: viewModel.animatingDrop,
                    onColumnTap: { column in
                        viewModel.dropPiece(in: column)
                    }
                )
                .padding(.horizontal)
                
                // Modus-Auswahl
                HStack(spacing: 4) {
                    modeButton(title: "2 Spieler", isSelected: !viewModel.singlePlayer) {
                        viewModel.singlePlayer = false
                        viewModel.startGame()
                    }
                    modeButton(title: "vs KI", isSelected: viewModel.singlePlayer) {
                        viewModel.singlePlayer = true
                        viewModel.startGame()
                    }
                }
                .padding(.horizontal, 40)
                
                HStack(spacing: 16) {
                    Button(action: {
                        viewModel.startGame()
                    }) {
                        Text(buttonText)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(viewModel.theme.buttonColor)
                            )
                    }
                    
                    Button(action: {
                        viewModel.toggleTheme()
                    }) {
                        Image(systemName: viewModel.theme == .wood ? "hammer.fill" : "leaf.fill")
                            .font(.title2)
                            .foregroundColor(viewModel.theme.textColor)
                            .padding(12)
                            .background(
                                Circle()
                                    .fill(viewModel.theme.boardColor.opacity(0.5))
                            )
                    }
                }
                
                Spacer()
            }
        }
    }
    
    private func modeButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundColor(isSelected ? .white : viewModel.theme.textColor)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isSelected ? viewModel.theme.buttonColor : viewModel.theme.boardColor.opacity(0.3))
                )
        }
    }
    
    private var buttonText: String {
        switch viewModel.gameState {
        case .idle: return "Spiel starten"
        default: return "Neues Spiel"
        }
    }
}
