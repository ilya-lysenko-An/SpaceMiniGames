//
//  PuzzleViewModel.swift
//  SpaceMiniGames
//
//  Created by Илья Лысенко on 08.10.2025.
//

import SwiftUI
import Combine

struct PuzzlePiece: Identifiable {
    let id = UUID()
    let number: Int
    let color: Color
    var isEmpty: Bool = false
}

class PuzzleViewModel: ObservableObject {
    @Published var currentLevel = 1
    @Published var movesCount = 0
    @Published var isLevelComplete = false
    @Published var puzzlePieces: [PuzzlePiece] = []
    
    // 🔥 ДОБАВЛЯЕМ CALLBACK ДЛЯ ОЧКОВ
    var onLevelComplete: ((Int) -> Void)?
    
    var gridSize: Int { 3 } // 3x3 grid
    private var emptyIndex: Int = 8 // Начинаем с последнего индекса
    
    let pieceColors: [Color] = [
        .red, .orange, .yellow, .green, .blue, .purple, .pink, .mint
    ]
    
    func startGame() {
        setupLevel()
    }
    
    func restartLevel() {
        movesCount = 0
        isLevelComplete = false
        setupLevel()
    }
    
    func nextLevel() {
        currentLevel += 1
        movesCount = 0
        isLevelComplete = false
        setupLevel()
    }
    
    func movePiece(at index: Int) {
        // Проверяем валидность индекса
        guard index >= 0 && index < puzzlePieces.count else { return }
        
        // Проверяем, можно ли переместить плитку (должна быть рядом с пустой)
        if canMovePiece(at: index) {
            // Меняем местами с пустой ячейкой
            puzzlePieces.swapAt(index, emptyIndex)
            emptyIndex = index
            movesCount += 1
            
            // Проверяем решение
            checkSolution()
        }
    }
    
    private func setupLevel() {
        puzzlePieces = []
        let totalPieces = gridSize * gridSize
        
        // Создаем упорядоченные плитки (1-8)
        for i in 0..<totalPieces - 1 {
            let color = pieceColors[i % pieceColors.count]
            puzzlePieces.append(PuzzlePiece(number: i + 1, color: color))
        }
        
        // Добавляем пустую плитку (последняя)
        puzzlePieces.append(PuzzlePiece(number: 0, color: .clear, isEmpty: true))
        emptyIndex = totalPieces - 1
        
        // Перемешиваем пазл
        shufflePuzzle()
    }
    
    private func shufflePuzzle() {
        // Делаем несколько случайных ходов для перемешивания
        let shuffleMoves = currentLevel * 10 + 10 // От 20 до 50 ходов в зависимости от уровня
        
        for _ in 0..<shuffleMoves {
            let possibleMoves = getPossibleMoves()
            if let randomMove = possibleMoves.randomElement() {
                // Безопасный обмен
                if randomMove >= 0 && randomMove < puzzlePieces.count {
                    puzzlePieces.swapAt(emptyIndex, randomMove)
                    emptyIndex = randomMove
                }
            }
        }
        movesCount = 0
    }
    
    private func canMovePiece(at index: Int) -> Bool {
        // Проверяем валидность индексов
        guard index >= 0 && index < puzzlePieces.count else { return false }
        guard emptyIndex >= 0 && emptyIndex < puzzlePieces.count else { return false }
        
        let row = index / gridSize
        let col = index % gridSize
        let emptyRow = emptyIndex / gridSize
        let emptyCol = emptyIndex % gridSize
        
        // Проверяем, соседняя ли ячейка (только по горизонтали/вертикали)
        let isAdjacent = (abs(row - emptyRow) == 1 && col == emptyCol) ||
                        (abs(col - emptyCol) == 1 && row == emptyRow)
        
        return isAdjacent && !puzzlePieces[index].isEmpty
    }
    
    private func getPossibleMoves() -> [Int] {
        var moves: [Int] = []
        let row = emptyIndex / gridSize
        let col = emptyIndex % gridSize
        
        // Проверяем все четыре направления
        if row > 0 {
            let upIndex = emptyIndex - gridSize
            if upIndex >= 0 && upIndex < puzzlePieces.count {
                moves.append(upIndex)
            }
        }
        
        if row < gridSize - 1 {
            let downIndex = emptyIndex + gridSize
            if downIndex >= 0 && downIndex < puzzlePieces.count {
                moves.append(downIndex)
            }
        }
        
        if col > 0 {
            let leftIndex = emptyIndex - 1
            if leftIndex >= 0 && leftIndex < puzzlePieces.count {
                moves.append(leftIndex)
            }
        }
        
        if col < gridSize - 1 {
            let rightIndex = emptyIndex + 1
            if rightIndex >= 0 && rightIndex < puzzlePieces.count {
                moves.append(rightIndex)
            }
        }
        
        return moves
    }
    
    private func checkSolution() {
        // Проверяем, все ли плитки на своих местах (1-8 по порядку)
        for i in 0..<puzzlePieces.count - 1 {
            if puzzlePieces[i].number != i + 1 {
                return // Не решено
            }
        }
        
        // Последняя плитка должна быть пустой
        if !puzzlePieces.last!.isEmpty {
            return
        }
        
        // Если дошли сюда - пазл решен!
        isLevelComplete = true
        
        // 🔥 ДОБАВЛЯЕМ НАЧИСЛЕНИЕ ОЧКОВ
        let pointsEarned = 3 // 3 очка за уровень
        onLevelComplete?(pointsEarned)
    }
}
