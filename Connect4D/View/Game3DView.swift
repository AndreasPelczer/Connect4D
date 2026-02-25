//
//  Game3DView.swift
//  Connect4D
//
//  Created by Andreas Pelczer on 25.02.26.
//

import SwiftUI

struct Game3DView: View {
    @State private var viewModel = GameViewModel3D()
    let config: GameConfig
    let theme: GameTheme
    let onBack: () -> Void
    
    var body: some View {
        ZStack {
            theme.backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 12) {
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
                
                HeaderView(
                    gameState: viewModel.gameState,
                    theme: theme
                )
                
                Game3DSceneView(
                    viewModel: viewModel,
                    theme: theme
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
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
                .padding(.bottom, 8)
            }
        }
        .onAppear {
            viewModel.singlePlayer = (config.opponentMode == .ai)
            viewModel.startGame()
        }
    }
}

