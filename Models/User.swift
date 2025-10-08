//
//  User.swift
//  SpaceMiniGames
//
//  Created by Илья Лысенко on 07.10.2025.
//

import Foundation

struct User: Codable {
    var username: String = "Space Explorer"
    var stars: Int = 0
    var unlockedPlanets: [String] = ["planet_1"]
    var totalScore: Int = 0  // ← Добавляем общий счет
    var rank: SpaceRank = .cadet  // ← Текущее звание
    var hasCompletedOnboarding: Bool = false
    
    // Настройки
    var isSoundEnabled: Bool = true
    var isMusicEnabled: Bool = true
    var isHapticEnabled: Bool = true
}

// Модель космического звания
enum SpaceRank: String, CaseIterable, Codable {
    case cadet = "Cadet"
    case ensign = "Ensign"
    case lieutenant = "Lieutenant"
    case captain = "Captain"
    case commander = "Commander"
    case admiral = "Admiral"
    case commodore = "Commodore"
    case fleetLeader = "Fleet Leader"
    case galacticHero = "Galactic Hero"
    case spaceLegend = "Space Legend"
    
    var emoji: String {
        switch self {
        case .cadet: return "🚀"
        case .ensign: return "🌟"
        case .lieutenant: return "🛰️"
        case .captain: return "👨‍🚀"
        case .commander: return "🪐"
        case .admiral: return "🌌"
        case .commodore: return "🚀"
        case .fleetLeader: return "💫"
        case .galacticHero: return "🌠"
        case .spaceLegend: return "🏆"
        }
    }
    
    var requiredScore: Int {
        switch self {
        case .cadet: return 0
        case .ensign: return 1000
        case .lieutenant: return 2500
        case .captain: return 5000
        case .commander: return 7500
        case .admiral: return 10000
        case .commodore: return 15000
        case .fleetLeader: return 20000
        case .galacticHero: return 30000
        case .spaceLegend: return 50000
        }
    }
    
    var nextRank: SpaceRank? {
        let allRanks = SpaceRank.allCases
        guard let currentIndex = allRanks.firstIndex(of: self),
              currentIndex < allRanks.count - 1 else { return nil }
        return allRanks[currentIndex + 1]
    }
    
    func progressToNextRank(with score: Int) -> Double {
        guard let nextRank = nextRank else { return 1.0 }
        
        let currentThreshold = requiredScore
        let nextThreshold = nextRank.requiredScore
        let progress = Double(score - currentThreshold) / Double(nextThreshold - currentThreshold)
        
        return max(0, min(1, progress))
    }
}

