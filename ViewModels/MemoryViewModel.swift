//
//  MemoryViewModel.swift
//  SpaceMiniGames
//
//  Created by Илья Лысенко on 08.10.2025.
//

import SwiftUI
import Combine

class MemoryViewModel: ObservableObject {
    @Published var score = 0
    @Published var level = 1
    @Published var gameStatus = "Watch the sequence..."
    @Published var isGameOver = false
    @Published var activeButtons: Set<Int> = []
    @Published var highlightedButtons: Set<Int> = []
    
    private var sequence: [Int] = []
    private var playerSequence: [Int] = []
    private var isShowingSequence = false
    private var isPlayerTurn = false
    private var timer: Timer?
    
    let buttonColors: [Color] = [
        .red, .orange, .yellow, .green, .blue, .purple, .pink, .cyan, .mint
    ]
    
    func startGame() {
        generateNewSequence()
        showSequence()
    }
    
    func restartGame() {
        score = 0
        level = 1
        sequence = []
        playerSequence = []
        isGameOver = false
        gameStatus = "Watch the sequence..."
        startGame()
    }
    
    func playerTap(index: Int) {
        guard isPlayerTurn else { return }
        
        // Добавляем ход игрока
        playerSequence.append(index)
        
        // Подсвечиваем кнопку
        highlightedButtons.insert(index)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.highlightedButtons.remove(index)
        }
        
        // Проверяем правильность
        checkPlayerSequence()
    }
    
    func isButtonActive(index: Int) -> Bool {
        return isPlayerTurn && !isShowingSequence
    }
    
    func isButtonHighlighted(index: Int) -> Bool {
        return highlightedButtons.contains(index)
    }
    
    func getButtonColor(for index: Int) -> Color {
        return buttonColors[index % buttonColors.count]
    }
    
    private func generateNewSequence() {
        let sequenceLength = level + 2 // Увеличиваем сложность
        sequence = []
        
        for _ in 0..<sequenceLength {
            sequence.append(Int.random(in: 0..<9))
        }
    }
    
    private func showSequence() {
        isShowingSequence = true
        isPlayerTurn = false
        gameStatus = "Watch the sequence..."
        playerSequence = []
        
        var delay: TimeInterval = 0.0
        
        for (index, buttonIndex) in sequence.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.highlightedButtons.insert(buttonIndex)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.highlightedButtons.remove(buttonIndex)
                    
                    // Если это последняя кнопка в последовательности
                    if index == self.sequence.count - 1 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.startPlayerTurn()
                        }
                    }
                }
            }
            delay += 1.2 // Задержка между кнопками
        }
    }
    
    private func startPlayerTurn() {
        isShowingSequence = false
        isPlayerTurn = true
        gameStatus = "Your turn! Repeat the sequence"
    }
    
    private func checkPlayerSequence() {
        let currentIndex = playerSequence.count - 1
        
        // Проверяем, совпадает ли ход игрока с последовательностью
        if playerSequence[currentIndex] != sequence[currentIndex] {
            gameOver()
            return
        }
        
        // Если игрок повторил всю последовательность
        if playerSequence.count == sequence.count {
            levelCompleted()
        }
    }
    
    private func levelCompleted() {
        score += level * 100
        level += 1
        gameStatus = "Perfect! Level \(level)"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.generateNewSequence()
            self.showSequence()
        }
    }
    
    private func gameOver() {
        isGameOver = true
        gameStatus = "Game Over! Final Score: \(score)"
    }
}
