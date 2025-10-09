//
//  ReactionGame.swift
//  SpaceMiniGames
//
//  Created by Илья Лысенко on 08.10.2025.
//

import SwiftUI

struct ReactionGame: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var gameVM = ReactionViewModel()
    
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
                            Text("TIME: \(gameVM.timeRemaining)s")
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
                        
                        // Появляющиеся планеты
                        ForEach(gameVM.activeTargets) { target in
                            PlanetTarget(target: target) {
                                gameVM.targetTapped(target.id)
                            }
                        }
                    }
                    .frame(width: 350, height: 500)
                    
                    // Инструкция
                    Text("Tap the planets before they disappear!")
                        .font(.headline)
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
                // Экран Game Over
                ReactionGameOverView(score: gameVM.score) {
                    gameVM.restartGame()
                } onExit: {
                    appState.currentScreen = .main
                }
            }
        }
        .onAppear {
                        gameVM.onGameComplete = { score in
                            print("🎯 Reaction Game completed! Score: \(score)")
                            appState.addGamePoints(gameType: "Reaction", basePoints: score)
                        }
            gameVM.startGame()
        }
    }
}

// Планета-цель
struct PlanetTarget: View {
    let target: ReactionTarget
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                Circle()
                    .fill(target.color)
                    .frame(width: target.size, height: target.size)
                
                Image(systemName: target.icon)
                    .font(.system(size: target.size / 3))
                    .foregroundColor(.white)
            }
        }
        .position(target.position)
        .opacity(target.opacity)
        .scaleEffect(target.scale)
    }
}

// Экран Game Over для Reaction Game
struct ReactionGameOverView: View {
    let score: Int
    let onRestart: () -> Void
    let onExit: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Text("TIME'S UP!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.orange)
            
            Image(systemName: "bolt.fill")
                .font(.system(size: 60))
                .foregroundColor(.yellow)
            
            Text("Final Score: \(score)")
                .font(.title2)
                .foregroundColor(.white)
            
            Text("Great reflexes, astronaut!")
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
