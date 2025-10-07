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
    @Published var user = User()  // ← ДОБАВЬ ЭТУ СТРОКУ!
    
    func saveSettings() {
        print("Settings saved: Sound - \(user.isSoundEnabled), Music - \(user.isMusicEnabled)")
    }
    
    func loadAppData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = false
            self.currentScreen = .onboarding
        }
    }
}

enum AppScreen {
    case launch
    case onboarding
    case main
    case game(planetId: String)
    case achievements
    case settings  // ← ДОБАВЬ settings!
}
