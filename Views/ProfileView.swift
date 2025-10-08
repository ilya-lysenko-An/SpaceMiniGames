//
//  ProfileView.swift
//  SpaceMiniGames
//
//  Created by Илья Лысенко on 08.10.2025.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            // Космический фон
            LinearGradient(
                colors: [.black, .blue, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Space Profile")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button("Done") {
                        appState.currentScreen = .main
                    }
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Аватар и основная информация
                        VStack(spacing: 15) {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.2))
                                    .frame(width: 120, height: 120)
                                
                                Text(appState.user.rank.emoji)
                                    .font(.system(size: 60))
                            }
                            
                            Text(appState.user.username)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text(appState.user.rank.rawValue)
                                .font(.title2)
                                .foregroundColor(.yellow)
                        }
                        
                        // Прогресс до следующего звания
                        VStack(spacing: 15) {
                            Text("Rank Progress")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            ProgressBarView(
                                progress: appState.user.rank.progressToNextRank(with: appState.user.totalScore),
                                currentRank: appState.user.rank,
                                nextRank: appState.user.rank.nextRank,
                                currentScore: appState.user.totalScore
                            )
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(16)
                        
                        // Статистика
                        VStack(spacing: 20) {
                            Text("Statistics")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            HStack {
                                StatCard(title: "Total Score", value: "\(appState.user.totalScore)", icon: "star.fill")
                                StatCard(title: "Current Rank", value: appState.user.rank.rawValue, icon: "medal.fill")
                            }
                            
                            HStack {
                                StatCard(title: "Games Played", value: "0", icon: "gamecontroller.fill")
                                StatCard(title: "Stars Earned", value: "\(appState.user.stars)", icon: "sparkles")
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(16)
                        
                        // Таблица всех званий
                        RankTableView(currentRank: appState.user.rank, currentScore: appState.user.totalScore)
                    }
                    .padding()
                }
            }
        }
    }
}

// Прогресс-бар
struct ProgressBarView: View {
    let progress: Double
    let currentRank: SpaceRank
    let nextRank: SpaceRank?
    let currentScore: Int
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text(currentRank.rawValue)
                    .font(.caption)
                    .foregroundColor(.white)
                
                Spacer()
                
                if let nextRank = nextRank {
                    Text(nextRank.rawValue)
                        .font(.caption)
                        .foregroundColor(.white)
                } else {
                    Text("MAX RANK")
                        .font(.caption)
                        .foregroundColor(.yellow)
                }
            }
            
            // Прогресс-бар
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.white.opacity(0.3))
                    .frame(height: 12)
                    .cornerRadius(6)
                
                Rectangle()
                    .fill(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                    .frame(width: CGFloat(progress) * 300, height: 12)
                    .cornerRadius(6)
                    .animation(.easeInOut(duration: 1.0), value: progress)
            }
            .frame(height: 12)
            
            if let nextRank = nextRank {
                Text("\(currentScore)/\(nextRank.requiredScore) points to \(nextRank.rawValue)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            } else {
                Text("Maximum rank achieved!")
                    .font(.caption)
                    .foregroundColor(.yellow)
            }
        }
    }
}

// Карточка статистики
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.yellow)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

// Таблица всех званий
struct RankTableView: View {
    let currentRank: SpaceRank
    let currentScore: Int
    
    var body: some View {
        VStack(spacing: 15) {
            Text("All Ranks")
                .font(.headline)
                .foregroundColor(.white)
            
            ForEach(SpaceRank.allCases, id: \.self) { rank in
                HStack {
                    Text(rank.emoji)
                        .font(.title2)
                    
                    VStack(alignment: .leading) {
                        Text(rank.rawValue)
                            .font(.body)
                            .foregroundColor(.white)
                        
                        Text("\(rank.requiredScore) points")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    Spacer()
                    
                    if currentRank == rank {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    } else if currentScore >= rank.requiredScore {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.blue)
                    } else {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(currentRank == rank ? Color.blue.opacity(0.3) : Color.white.opacity(0.05))
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
    }
}
