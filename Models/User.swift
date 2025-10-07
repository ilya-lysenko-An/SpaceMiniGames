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
    
    // Настройки
    var isSoundEnabled: Bool = true
    var isMusicEnabled: Bool = true
    var isHapticEnabled: Bool = true
}

