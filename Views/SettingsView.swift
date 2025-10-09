//
//  SettingsView.swift
//  SpaceMiniGames
//
//  Created by Илья Лысенко on 07.10.2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @FocusState private var isTextFieldFocused: Bool
    
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
                // Заголовок в стиле профиля
                HStack {
                    Text("Settings")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button("Done") {
                        print(" Settings Done pressed")
                        appState.saveSettings()        // ← СОХРАНЯЕМ НАСТРОЙКИ!
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
                
                // Список настроек со стеклянным эффектом
                ScrollView {
                    VStack(spacing: 20) {
                        // Аудио настройки
                        GlassCard {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("AUDIO")
                                    .font(.headline)
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Toggle("Sound Effects", isOn: $appState.user.isSoundEnabled)
                                    .foregroundColor(.white)
                                
                                Toggle("Background Music", isOn: $appState.user.isMusicEnabled)
                                    .foregroundColor(.white)
                            }
                        }
                        
                        // Вибрация
                        GlassCard {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("VIBRATION")
                                    .font(.headline)
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Toggle("Haptic Feedback", isOn: $appState.user.isHapticEnabled)
                                    .foregroundColor(.white)
                            }
                        }
                        
                        // Игрок
                        GlassCard {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("PLAYER")
                                    .font(.headline)
                                    .foregroundColor(.white.opacity(0.8))
                                
                                TextField("Player Name", text: $appState.user.username)
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(8)
                                    .focused($isTextFieldFocused) //  ДОБАВЛЯЕМ ФОКУС
                                    .onChange(of: appState.user.username) { _ in
                                        appState.saveSettings()
                                    }
                            }
                        }
                        
                        // Обучение
                        GlassCard {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("TUTORIAL")
                                    .font(.headline)
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Button("Show Onboarding Again") {
                                    appState.resetOnboarding()
                                    appState.currentScreen = .onboarding
                                }
                                .foregroundColor(.white)
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                        
                        // Информация
                        GlassCard {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("ABOUT")
                                    .font(.headline)
                                    .foregroundColor(.white.opacity(0.8))
                                
                                HStack {
                                    Text("Version")
                                    Spacer()
                                    Text("1.0.0")
                                        .foregroundColor(.white.opacity(0.6))
                                }
                                .foregroundColor(.white)
                                
                                HStack {
                                    Text("Games Available")
                                    Spacer()
                                    Text("4")
                                        .foregroundColor(.white.opacity(0.6))
                                }
                                .foregroundColor(.white)
                            }
                        }
                    }
                    .padding()
                }
            }
            .onTapGesture {

                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                to: nil, from: nil, for: nil)
            }
        }
    }
    
    // Компонент стеклянной карточки
    struct GlassCard<Content: View>: View {
        let content: Content
        
        init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }
        
        var body: some View {
            content
                .padding(20)
                .background(Color.white.opacity(0.1))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        }
    }
}
