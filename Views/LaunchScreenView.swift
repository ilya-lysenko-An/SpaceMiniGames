//
//  LaunchScreenView.swift
//  SpaceMiniGames
//
//  Created by Илья Лысенко on 07.10.2025.
//
import SwiftUI

struct LaunchScreenView: View {
    @EnvironmentObject var appState: AppState
    @State private var scale = 0.5
    @State private var opacity = 0.0
    @State private var rotation = 0.0
    
    var body: some View {
        ZStack {
            // Space background
            LinearGradient(
                colors: [.black, .blue, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                // Animated planet
                Image(systemName: "globe.americas.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.white)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .rotationEffect(.degrees(rotation))
                
                // App title
                Text("SPACE")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .opacity(opacity)
                
                Text("ADVENTURE")
                    .font(.title2)
                    .foregroundColor(.yellow)
                    .opacity(opacity)
                    .padding(.top, 5)
            }
        }
        .onAppear {
            // Start animations
            withAnimation(.easeInOut(duration: 2.0)) {
                scale = 1.0
                opacity = 1.0
                rotation = 360
            }
        }
    }
}
