//
//  ReactionViewModel.swift
//  SpaceMiniGames
//
//  Created by Илья Лысенко on 08.10.2025.
//

import SwiftUI
import Combine

struct ReactionTarget: Identifiable {
    let id = UUID()
    let position: CGPoint
    let size: CGFloat
    let color: Color
    let icon: String
    var opacity: Double = 1.0
    var scale: CGFloat = 1.0
    let spawnTime: Date
}

class ReactionViewModel: ObservableObject {
    @Published var score = 0
    @Published var timeRemaining = 60
    @Published var isGameOver = false
    @Published var activeTargets: [ReactionTarget] = []
    
    // 🔥 ДОБАВЛЯЕМ ЭТУ СТРОКУ - callback для очков
    var onGameComplete: ((Int) -> Void)?
    
    private var timer: Timer?
    private var spawnTimer: Timer?
    private let gameWidth: CGFloat = 350
    private let gameHeight: CGFloat = 500
    
    let planetIcons = ["globe", "moon.fill", "star.fill", "circle.fill", "sparkles"]
    let planetColors: [Color] = [.red, .green, .blue, .yellow, .orange, .purple, .pink]
    
    func startGame() {
        timeRemaining = 60
        score = 0
        isGameOver = false
        activeTargets = []
        
        // Таймер обратного отсчета
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
        
        // Таймер появления целей
        spawnTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.spawnTarget()
        }
    }
    
    func restartGame() {
        timer?.invalidate()
        spawnTimer?.invalidate()
        startGame()
    }
    
    func targetTapped(_ targetId: UUID) {
        if let index = activeTargets.firstIndex(where: { $0.id == targetId }) {
            // Удаляем цель и добавляем очки
            activeTargets.remove(at: index)
            score += 1
            
            // Бонус за быстрый тап
            score += 1
        }
    }
    
    private func updateTimer() {
        timeRemaining -= 1
        
        if timeRemaining <= 0 {
            gameOver()
        }
        
        // Убираем старые цели
        let now = Date()
        activeTargets.removeAll { target in
            now.timeIntervalSince(target.spawnTime) > 3.0 // Цели живут 3 секунды
        }
    }
    
    private func gameOver() {
        timer?.invalidate()
        spawnTimer?.invalidate()
        
        // 🔥 ДОБАВЛЯЕМ ВЫЗОВ CALLBACK С ОЧКАМИ
        onGameComplete?(score)
        
        isGameOver = true
    }
    
    private func spawnTarget() {
        let target = ReactionTarget(
            position: CGPoint(
                x: CGFloat.random(in: 50...(gameWidth - 50)),
                y: CGFloat.random(in: 50...(gameHeight - 50))
            ),
            size: CGFloat.random(in: 40...70),
            color: planetColors.randomElement() ?? .blue,
            icon: planetIcons.randomElement() ?? "globe",
            spawnTime: Date()
        )
        
        activeTargets.append(target)
        
        // Автоматическое исчезновение через 2.5 секунды
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            if let index = self.activeTargets.firstIndex(where: { $0.id == target.id }) {
                withAnimation(.easeOut(duration: 0.3)) {
                    self.activeTargets.remove(at: index)
                }
            }
        }
    }
    
    deinit {
        timer?.invalidate()
        spawnTimer?.invalidate()
    }
}
