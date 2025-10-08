//
//  CustomOnboardingView.swift
//  SpaceMiniGames
//
//  Created by Илья Лысенко on 08.10.2025.
//

import SwiftUI

struct CustomOnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentPage = 0
    @State private var footerOpacity = 0.0
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.black, .blue, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                // Простая замена TabView
                Group {
                    if currentPage == 0 {
                        OnboardingPage1()
                    } else if currentPage == 1 {
                        OnboardingPage2()
                    } else {
                        OnboardingPage3()
                    }
                }
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                onboardingFooter
                    .opacity(footerOpacity)
            }
        }
        .onChange(of: currentPage) { newPage in
            footerOpacity = 0.0
            startFooterAnimation()
        }
        .onAppear {
            startFooterAnimation()
        }
    }
    
    private func startFooterAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeIn(duration: 0.8)) {
                footerOpacity = 1.0
            }
        }
    }
    
    private var onboardingFooter: some View {
        VStack {
            HStack(spacing: 8) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ? Color.white : Color.gray)
                        .frame(width: 8, height: 8)
                }
            }
            
            Button(action: {
                withAnimation {
                    if currentPage < 2 {
                        currentPage += 1
                    } else {
                        appState.currentScreen = .main
                    }
                }
            }) {
                Text(currentPage == 2 ? "Start Journey" : "Next")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.yellow)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            .padding(.top, 20)
        }
        .padding(.bottom, 50)
    }
}
