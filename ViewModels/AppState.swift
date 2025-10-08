//
//  AppState.swift
//  SpaceMiniGames
//
//  Created by Илья Лысенко on 07.10.2025.
//

import Foundation
import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var currentScreen: AppScreen = .launch
    @Published var isLoading = true
    @Published var user = User()
    
    func saveSettings() {
        print("Settings saved: Sound - \(user.isSoundEnabled), Music - \(user.isMusicEnabled)")
    }
    
    func loadAppData() {
        print("🚀 Starting app loading...")
        
        // Имитация загрузки данных
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print("✅ App loading complete - switching to onboarding")
            self.isLoading = false
            self.currentScreen = .onboarding
        }
    }
    
    func addToTotalScore(_ points: Int) {
        user.totalScore += points
        updateRankIfNeeded()
    }

    private func updateRankIfNeeded() {
        let currentRank = user.rank
        let newRank = SpaceRank.allCases.last { $0.requiredScore <= user.totalScore } ?? .cadet
        
        if newRank != currentRank {
            user.rank = newRank
            // Здесь позже добавим уведомление о новом звании
            print("🎉 New rank achieved: \(newRank.rawValue)")
        }
    }
}

enum AppScreen: Equatable {
    case launch
    case onboarding
    case main
    case game(planetId: String)
    case achievements
    case settings
    case profile
}


