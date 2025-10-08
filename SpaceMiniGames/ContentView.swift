//
//  ContentView.swift
//  SpaceMiniGames
//
//  Created by Илья Лысенко on 07.10.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var appState = AppState()
    
    var body: some View {
        Group {
            switch appState.currentScreen {
            case .launch:
                LaunchScreenView()
            case .onboarding:
                CustomOnboardingView()
            case .main:
                MainGalaxyView()
            case .game(let planetId):
                GameView(planetId: planetId)
            case .achievements:
                AchievementsView()
            case .settings:
                SettingsView()
            }
        }
        .environmentObject(appState)
        .onAppear {
            print("📱 ContentView appeared")
            appState.loadAppData()
        }
        .onChange(of: appState.currentScreen) { newScreen in
            print("🔄 Screen changed to: \(newScreen)")
        }
    }
}

