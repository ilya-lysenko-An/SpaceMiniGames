//
//  GameView.swift
//  SpaceMiniGames
//
//  Created by Илья Лысенко on 08.10.2025.
//

// Views/GameView.swift
import SwiftUI

struct GameView: View {
    let planetId: String
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        switch planetId {
        case "arkanoid":
            ArkanoidGame()
        case "memory":
            MemoryGame()
        default:
            // Заглушка для неизвестных игр
            DefaultGameView(planetId: planetId)
        }
    }
}

// Временная заглушка
struct DefaultGameView: View {
    let planetId: String
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, .blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack {
                Text("Game: \(planetId)")
                    .font(.title)
                    .foregroundColor(.white)
                
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
