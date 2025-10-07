//
//  PlaceholderViews.swift
//  SpaceMiniGames
//
//  Created by Илья Лысенко on 07.10.2025.
//

import SwiftUI

// Временные заглушки для всех экранов
struct MainGalaxyView: View {
    var body: some View {
        Text("Main Galaxy")
    }
}

struct GameView: View {
    let planetId: String
    var body: some View {
        Text("Game: \(planetId)")
    }
}

struct AchievementsView: View {
    var body: some View {
        Text("Achievements")
    }
}


