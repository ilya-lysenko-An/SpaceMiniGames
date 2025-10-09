//
//  ArkanoidViewModel.swift
//  SpaceMiniGames
//
//  Created by Илья Лысенко on 08.10.2025.
//

import SwiftUI
import Combine

class ArkanoidViewModel: ObservableObject {
    @Published var score = 0
    @Published var lives = 3
    @Published var ballPosition = CGPoint(x: 175, y: 250)
    @Published var paddlePosition = CGPoint(x: 175, y: 480)
    @Published var blocks: [GameBlock] = []
    @Published var isGameOver = false
    @Published var isVictory = false
    
    var onGameComplete: ((Int, Bool) -> Void)?
    
    let paddleWidth: CGFloat = 80
    private var ballSpeed = CGSize(width: 3, height: -3)
    private var timer: Timer?
    private let gameWidth: CGFloat = 350
    private let gameHeight: CGFloat = 500
    
    struct GameBlock: Identifiable {
        let id = UUID()
        var position: CGPoint
        let width: CGFloat = 50
        let height: CGFloat = 20
        var color: Color
        var isDestroyed = false
    }
    
    init() {
        setupBlocks()
    }
    
    func startGame() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { [weak self] _ in
            self?.updateGame()
        }
    }
    
    func restartGame() {
        score = 0
        lives = 3
        ballPosition = CGPoint(x: 175, y: 250)
        paddlePosition = CGPoint(x: 175, y: 480)
        ballSpeed = CGSize(width: 3, height: -3)
        isGameOver = false  // ← Сбрасываем состояния
        isVictory = false   // ← Сбрасываем состояния
        setupBlocks()
        startGame()  // ← Запускаем игру заново
    }
    
    func movePaddle(to xPosition: CGFloat) {
        let minX = paddleWidth / 2
        let maxX = gameWidth - paddleWidth / 2
        let newX = min(max(xPosition, minX), maxX)
        paddlePosition = CGPoint(x: newX, y: paddlePosition.y)
    }
    
    private func setupBlocks() {
        blocks = []
        let colors: [Color] = [.red, .orange, .yellow, .green, .blue]
        
        for row in 0..<4 {
            for column in 0..<6 {
                let x = CGFloat(column) * 55 + 40
                let y = CGFloat(row) * 30 + 80
                let color = colors[row % colors.count]
                
                blocks.append(GameBlock(
                    position: CGPoint(x: x, y: y),
                    color: color
                ))
            }
        }
    }
    
    private func gameOver() {
        timer?.invalidate()
        
        //  ДОБАВЛЯЕМ ВЫЗОВ ОЧКОВ ДЛЯ ПРОИГРЫША
        onGameComplete?(score, false) // false = проигрыш
        
        isGameOver = true
    }
    
    private func victory() {
        timer?.invalidate()
        
        //  ДОБАВЛЯЕМ ВЫЗОВ ОЧКОВ ДЛЯ ПОБЕДЫ
        let victoryBonus = 5
        let totalPoints = score + victoryBonus
        onGameComplete?(totalPoints, true) // true = победа
        
        isVictory = true
    }
    
    private func updateGame() {
        // Движение шарика
        ballPosition.x += ballSpeed.width
        ballPosition.y += ballSpeed.height
        
        // Столкновение со стенами
        if ballPosition.x <= 0 || ballPosition.x >= gameWidth {
            ballSpeed.width *= -1
        }
        
        if ballPosition.y <= 0 {
            ballSpeed.height *= -1
        }
        
        // Столкновение с полом (потеря жизни)
        if ballPosition.y >= gameHeight {
            lives -= 1
            resetBall()
            if lives <= 0 {
                gameOver()
            }
        }
        
        // Столкновение с платформой
        if ballPosition.y >= paddlePosition.y - 10 &&
           ballPosition.y <= paddlePosition.y + 10 &&
           ballPosition.x >= paddlePosition.x - paddleWidth / 2 &&
           ballPosition.x <= paddlePosition.x + paddleWidth / 2 {
            ballSpeed.height = -abs(ballSpeed.height) // Всегда вверх
        }
        
        // Столкновение с блоками
        checkBlockCollisions()
    }
    
    private func resetBall() {
        ballPosition = CGPoint(x: 175, y: 250)
        ballSpeed = CGSize(width: 3, height: -3)
    }
    
    private func checkBlockCollisions() {
        for index in blocks.indices {
            var block = blocks[index]
            if !block.isDestroyed &&
               ballPosition.x >= block.position.x - block.width / 2 &&
               ballPosition.x <= block.position.x + block.width / 2 &&
               ballPosition.y >= block.position.y - block.height / 2 &&
               ballPosition.y <= block.position.y + block.height / 2 {
                
                block.isDestroyed = true
                blocks[index] = block
                score += 10
                ballSpeed.height *= -1
                
                // Проверка победы
                if blocks.allSatisfy({ $0.isDestroyed }) {
                    victory()
                }
            }
        }
    }
    
    
    deinit {
        timer?.invalidate()
    }
}
