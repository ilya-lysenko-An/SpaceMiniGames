//
//  PuzzleGame.swift
//  SpaceMiniGames
//
//  Created by Илья Лысенко on 08.10.2025.
//

import SwiftUI

struct PuzzleGame: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var gameVM = PuzzleViewModel()
    
    var body: some View {
        ZStack {
            // Космический фон
            LinearGradient(
                colors: [.black, .blue, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            if !gameVM.isLevelComplete {
                VStack(spacing: 20) {
                    // Статус бар
                    HStack {
                        VStack(alignment: .leading) {
                            Text("LEVEL: \(gameVM.currentLevel)")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("MOVES: \(gameVM.movesCount)")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Button("Restart") {
                            gameVM.restartLevel()
                        }
                        .padding(8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    // Игровое поле
                    VStack(spacing: 10) {
                        Text("Solve the puzzle!")
                            .font(.title2)
                            .foregroundColor(.white)
                        
                        // Сетка пазла
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: gameVM.gridSize), spacing: 2) {
                            ForEach(gameVM.puzzlePieces) { piece in
                                PuzzlePieceView(
                                    piece: piece,
                                    onTap: {
                                        if let index = gameVM.puzzlePieces.firstIndex(where: { $0.id == piece.id }) {
                                            gameVM.movePiece(at: index)
                                        }
                                    }
                                )
                            }
                        }
                        .frame(width: 300, height: 300)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(12)
                    }
                    
                    // Подсказка
                    Text("Tap pieces to move them to empty space")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
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
                // Экран завершения уровня
                PuzzleCompleteView(level: gameVM.currentLevel, moves: gameVM.movesCount) {
                    gameVM.nextLevel()
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

// Пазл-плитка
struct PuzzlePieceView: View {
    let piece: PuzzlePiece
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                if piece.isEmpty {
                    // Пустая ячейка
                    Rectangle()
                        .fill(Color.black.opacity(0.3))
                        .frame(height: 70)
                } else {
                    // Ячейка с номером
                    Rectangle()
                        .fill(piece.color)
                        .frame(height: 70)
                    
                    Text("\(piece.number)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
        }
        .disabled(piece.isEmpty)
        .cornerRadius(6)
    }
}

// Экран завершения уровня
struct PuzzleCompleteView: View {
    let level: Int
    let moves: Int
    let onNext: () -> Void
    let onExit: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Text("PUZZLE SOLVED!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.green)
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            VStack(spacing: 10) {
                Text("Level \(level) Complete!")
                    .font(.title2)
                    .foregroundColor(.white)
                
                Text("Moves: \(moves)")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            VStack(spacing: 15) {
                Button("Next Level") {
                    onNext()
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
