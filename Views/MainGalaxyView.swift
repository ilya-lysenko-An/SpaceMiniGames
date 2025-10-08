//
//  MainGalaxyView.swift
//  SpaceMiniGames
//
//  Created by Илья Лысенко on 08.10.2025.
//

import SwiftUI

struct MainGalaxyView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            ZStack {
                // Космический фон
                LinearGradient(
                    colors: [.black, .blue, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        Text("Galaxy Map")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 20) {
                            // Планета 1 - Арканоид
                            PlanetCard(
                                title: "Asteroid Field",
                                subtitle: "Arkanoid Game",
                                systemImage: "circle.grid.2x2.fill",
                                color: .orange,
                                isLocked: false,
                                stars: 0
                            ) {
                                appState.currentScreen = .game(planetId: "arkanoid")
                            }
                            
                            // Планета 2 - Память
                            PlanetCard(
                                title: "Memory Nebula",
                                subtitle: "Memory Game",
                                systemImage: "brain.head.profile",
                                color: .blue,
                                isLocked: false,
                                stars: 0
                            ) {
                                appState.currentScreen = .game(planetId: "memory")
                            }
                            
                            // Планета 3 - реакция 
                            PlanetCard(
                                title: "Cosmic Reaction",
                                subtitle: "Speed Test",
                                systemImage: "bolt.fill",
                                color: .yellow,
                                isLocked: false,
                                stars: 0
                            ) {
                                appState.currentScreen = .game(planetId: "reaction")
                            }
                            
                            // планета 4 - пазл 
                            PlanetCard(
                                title: "Space Puzzle",
                                subtitle: "Logic Game",
                                systemImage: "square.grid.3x3.fill",
                                color: .purple,
                                isLocked: false,
                                stars: 0
                            ) {
                                appState.currentScreen = .game(planetId: "puzzle")
                            }
                            
                            PlanetCard(
                                title: "???",
                                subtitle: "Locked",
                                systemImage: "lock.fill",
                                color: .gray,
                                isLocked: true,
                                stars: 0
                            ) {
                                // Заблокировано
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 20)
                }
                
                // Кнопка настроек
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            appState.currentScreen = .settings
                        }) {
                            Image(systemName: "gearshape.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .clipShape(Circle())
                        }
                    }
                    Spacer()
                }
                .padding()
            }
        }
    }
}

// Компонент карточки планеты
struct PlanetCard: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let color: Color
    let isLocked: Bool
    let stars: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.3))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: systemImage)
                        .font(.title2)
                        .foregroundColor(isLocked ? .gray : color)
                    
                    if isLocked {
                        Circle()
                            .fill(Color.black.opacity(0.7))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "lock.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(isLocked ? .gray : .white)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(isLocked ? .gray : .white.opacity(0.8))
                
                // Звезды за прохождение
                if stars > 0 {
                    HStack(spacing: 2) {
                        ForEach(0..<3, id: \.self) { index in
                            Image(systemName: index < stars ? "star.fill" : "star")
                                .font(.caption)
                                .foregroundColor(.yellow)
                        }
                    }
                }
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
        }
        .disabled(isLocked)
    }
}
