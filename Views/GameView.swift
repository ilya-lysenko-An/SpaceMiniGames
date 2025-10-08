//
//  GameView.swift
//  SpaceMiniGames
//
//  Created by Илья Лысенко on 08.10.2025.
//

import SwiftUI

struct GameView: View {
    let planetId: String
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.black, .blue, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Game: \(planetId)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("This game is under development")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                
                Button("Back to Galaxy") {
                    appState.currentScreen = .main
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
    }
}
