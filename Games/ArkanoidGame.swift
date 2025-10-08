//
//  ArkanoidGame.swift
//  SpaceMiniGames
//
//  Created by Илья Лысенко on 08.10.2025.
//

import SwiftUI

struct ArkanoidGame: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var gameVM = ArkanoidViewModel()
    
    var body: some View {
        ZStack {
            // Космический фон
            LinearGradient(
                colors: [.black, .blue, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Основной игровой интерфейс (показывается когда игра активна)
            if !gameVM.isGameOver && !gameVM.isVictory {
                VStack(spacing: 20) {
                    // Статус бар
                    HStack {
                        VStack(alignment: .leading) {
                            Text("SCORE: \(gameVM.score)")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("LIVES: \(gameVM.lives)")
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
                        Rectangle()
                            .fill(Color.black.opacity(0.3))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.5), lineWidth: 2)
                            )
                        
                        GameElementsView(gameVM: gameVM)
                    }
                    .frame(width: 350, height: 500)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                gameVM.movePaddle(to: value.location.x)
                            }
                    )
                    
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
            }
            
            // Экран Game Over
            if gameVM.isGameOver {
                GameOverView(score: gameVM.score) {
                    gameVM.restartGame()
                } onExit: {
                    appState.currentScreen = .main
                }
            }
            
            // Экран Victory
            if gameVM.isVictory {
                VictoryView(score: gameVM.score) {
                    gameVM.restartGame()
                } onExit: {
                    appState.currentScreen = .main
                }
            }
        }
        .onAppear {
            gameVM.startGame()
        }
    }
}

// Экран Game Over
struct GameOverView: View {
    let score: Int
    let onRestart: () -> Void
    let onExit: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Text("GAME OVER")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.red)
            
            Text("Final Score: \(score)")
                .font(.title2)
                .foregroundColor(.white)
            
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

// Экран Victory
struct VictoryView: View {
    let score: Int
    let onRestart: () -> Void
    let onExit: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Text("VICTORY!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.yellow)
            
            Image(systemName: "trophy.fill")
                .font(.system(size: 60))
                .foregroundColor(.yellow)
            
            Text("Final Score: \(score)")
                .font(.title2)
                .foregroundColor(.white)
            
            Text("All asteroids destroyed!")
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
            
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

// GameElementsView остается без изменений
struct GameElementsView: View {
    @ObservedObject var gameVM: ArkanoidViewModel
    
    var body: some View {
        ZStack {
            // Шарик
            Circle()
                .fill(Color.yellow)
                .frame(width: 15, height: 15)
                .position(gameVM.ballPosition)
            
            // Платформа
            Rectangle()
                .fill(Color.white)
                .frame(width: gameVM.paddleWidth, height: 15)
                .position(gameVM.paddlePosition)
            
            // Блоки (астероиды)
            ForEach(gameVM.blocks) { block in
                if !block.isDestroyed {
                    Rectangle()
                        .fill(block.color)
                        .frame(width: block.width, height: block.height)
                        .position(block.position)
                        .cornerRadius(4)
                }
            }
        }
    }
}
