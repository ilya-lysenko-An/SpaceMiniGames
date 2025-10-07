//
//  SettingsView.swift
//  SpaceMiniGames
//
//  Created by Илья Лысенко on 07.10.2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("AUDIO")) {
                    Toggle("Sound Effects", isOn: $appState.user.isSoundEnabled)
                    Toggle("Background Music", isOn: $appState.user.isMusicEnabled)
                }
                
                Section(header: Text("VIBRATION")) {
                    Toggle("Haptic Feedback", isOn: $appState.user.isHapticEnabled)
                }
                
                Section(header: Text("PLAYER")) {
                    TextField("Player Name", text: $appState.user.username)
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(
                trailing: Button("Done") {
                    appState.saveSettings()
                    dismiss()
                }
            )
        }
    }
}
