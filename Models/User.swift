//
//  User.swift
//  SpaceMiniGames
//
//  Created by Илья Лысенко on 07.10.2025.
//

import Foundation

struct User: Codable {
    var username: String = "Космонавт"
    var stars: Int = 0
    var unlockedPlanets: [String] = ["planet_1"]
}

