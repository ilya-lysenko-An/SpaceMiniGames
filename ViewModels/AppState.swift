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
    
    private let dataService = DataService() // ← Используем наш сервис
    
    init() {
        loadUserData() // ← Загружаем данные при создании
    }
    
    /* func saveSettings() {
        dataService.saveUser(user)
        print("Settings saved: Sound - \(user.isSoundEnabled), Music - \(user.isMusicEnabled)")
    } */
    
    func loadAppData() {
        print("🚀 Starting app loading...")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print("✅ App loading complete")
            self.isLoading = false
            
            if self.user.hasCompletedOnboarding {
                self.currentScreen = .main
                print("🎯 User has completed onboarding - going to main screen")
            } else {
                self.currentScreen = .onboarding
                print("🆕 First launch - showing onboarding")
            }
        }
    }
    
    func completeOnboarding() {
        print("🎉 COMPLETE ONBOARDING CALLED!")
        user.hasCompletedOnboarding = true
        dataService.saveUser(user)
        print("💾 Saved user with onboarding: \(user.hasCompletedOnboarding)")
        currentScreen = .main
    }
    
   /* func completeOnboarding() {
        user.hasCompletedOnboarding = true
        dataService.saveUser(user)
        currentScreen = .main
        print("🎉 Onboarding completed and saved")
    } */

    func resetOnboarding() {
        user.hasCompletedOnboarding = false
        dataService.saveUser(user)
        print("🔄 Onboarding reset")
    }
    
    func addToTotalScore(_ points: Int) {
        user.totalScore += points
        updateRankIfNeeded()
        dataService.saveUser(user)
    }
    
    private func updateRankIfNeeded() {
        let currentRank = user.rank
        let newRank = SpaceRank.allCases.last { $0.requiredScore <= user.totalScore } ?? .cadet
        
        if newRank != currentRank {
            user.rank = newRank
            dataService.saveUser(user)
            print("🎉 New rank achieved: \(newRank.rawValue)")
        }
    }
    
    func addGamePoints(gameType: String, basePoints: Int, bonus: Int = 0) {
            let pointsEarned = basePoints + bonus 
            
            print("🎮 \(gameType): \(basePoints) + \(bonus) = \(pointsEarned) points")
            
            addToTotalScore(pointsEarned)
        }
    
    private func loadUserData() {
        let savedUser = dataService.loadUser()
        self.user = savedUser
        
        print("🔍 DEBUG loadUserData:")
        print("   - Username: '\(savedUser.username)'")
        print("   - Score: \(savedUser.totalScore)")
        print("   - Onboarding: \(savedUser.hasCompletedOnboarding)")
        print("   - Sound: \(savedUser.isSoundEnabled)")
        print("   - Music: \(savedUser.isMusicEnabled)")
    }

    func saveSettings() {
        print("🔍 DEBUG saveSettings:")
        print("   - Username: '\(user.username)'")
        print("   - Onboarding: \(user.hasCompletedOnboarding)")
        dataService.saveUser(user)
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

