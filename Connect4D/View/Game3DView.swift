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
                    .accessibilityLabel("Zurück zum Menü")
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
                .accessibilityLabel("3D Spielbrett")
                .accessibilityHint("Tippe auf eine Stange um einen Stein einzuwerfen")
                
                HStack(spacing: 16) {
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

                    Button(action: {
                        SoundManager.shared.isMuted.toggle()
                    }) {
                        Image(systemName: SoundManager.shared.isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                            .font(.title3)
                            .foregroundColor(theme.textColor.opacity(0.7))
                    }
                    .accessibilityLabel(SoundManager.shared.isMuted ? "Ton einschalten" : "Ton ausschalten")
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

