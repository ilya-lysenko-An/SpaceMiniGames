//
//  MemoryGame.swift
//  SpaceMiniGames
//
//  Created by Илья Лысенко on 08.10.2025.
//

import SwiftUI

struct MemoryGame: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var gameVM = MemoryViewModel()
    
    var body: some View {
        ZStack {
            // Космический фон
            LinearGradient(
                colors: [.black, .blue, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            if !gameVM.isGameOver {
                VStack(spacing: 20) {
                    // Статус бар
                    HStack {
                        VStack(alignment: .leading) {
                            Text("LEVEL: \(gameVM.level)")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("SCORE: \(gameVM.score)")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Button("Restart") {
                            gameVM.restartGame()
                        }
                        .padding(8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    // Игровое поле
                    ZStack {
                        // Фон игрового поля
                        Rectangle()
                            .fill(Color.black.opacity(0.3))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.5), lineWidth: 2)
                            )
                        
                        // Созвездия
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
                            ForEach(0..<9, id: \.self) { index in
                                ConstellationButton(
                                    index: index,
                                    gameVM: gameVM
                                )
                            }
                        }
                        .padding(30)
                    }
                    .frame(width: 350, height: 400)
                    
                    // Статус игры
                    Text(gameVM.gameStatus)
                        .font(.title2)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Кнопка назад
                    Button("Back to Galaxy") {
                        appState.currentScreen = .main
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Spacer()
                }
                .padding(.top, 20)
            } else {
                // Экран Game Over для Memory Game
                MemoryGameOverView(score: gameVM.score, level: gameVM.level) {
                    gameVM.restartGame()
                } onExit: {
                    appState.currentScreen = .main
                }
            }
        }
        .onAppear {
            gameVM.onLevelComplete = { points in
                    print("🧠 Memory Level completed! Points: \(points)")
                    appState.addGamePoints(gameType: "Memory", basePoints: points)
                }
                gameVM.startGame()
        }
    }
}

// Кнопка созвездия
struct ConstellationButton: View {
    let index: Int
    @ObservedObject var gameVM: MemoryViewModel
    
    var body: some View {
        Button(action: {
            gameVM.playerTap(index: index)
        }) {
            ZStack {
                Circle()
                    .fill(gameVM.getButtonColor(for: index))
                    .frame(width: 70, height: 70)
                
                Image(systemName: "star.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .opacity(gameVM.isButtonActive(index: index) ? 1.0 : 0.3)
            }
        }
        .disabled(!gameVM.isButtonActive(index: index))
        .scaleEffect(gameVM.isButtonHighlighted(index: index) ? 1.2 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: gameVM.isButtonHighlighted(index: index))
    }
}

// Экран Game Over для Memory Game
struct MemoryGameOverView: View {
    let score: Int
    let level: Int
    let onRestart: () -> Void
    let onExit: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Text("GAME OVER")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.red)
            
            Image(systemName: "brain.head.profile")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            VStack(spacing: 10) {
                Text("Reached Level: \(level)")
                    .font(.title2)
                    .foregroundColor(.white)
                
                Text("Final Score: \(score)")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 15) {
                Button("Play Again") {
                    onRestart()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(12)
                
                Button("Back to Galaxy") {
                    onExit()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding(.horizontal, 40)
        }
        .padding()
        .background(Color.black.opacity(0.8))
        .cornerRadius(20)
        .padding(40)
    }
}
