//
//  OnboardingView.swift
//  SpaceMiniGames
//
//  Created by Илья Лысенко on 07.10.2025.
//

// Первая страница онбординга
import SwiftUI

struct OnboardingView: View {
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
                // Ключевое изменение: добавляем .id() чтобы пересоздавать View
                TabView(selection: $currentPage) {
                    OnboardingPage1()
                        .tag(0)
                        .id(0) // ← Добавляем id
                    
                    OnboardingPage2()
                        .tag(1)
                        .id(1) // ← Добавляем id
                    
                    OnboardingPage3()
                        .tag(2)
                        .id(2) // ← Добавляем id
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                onboardingFooter
                    .opacity(footerOpacity)
            }
        }
        .onChange(of: currentPage) { newPage in
            footerOpacity = 0.0
            startFooterAnimation()
            
            // Принудительно обновляем состояние для анимаций
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                // Это заставит SwiftUI пересоздать View и вызвать onAppear
            }
        }
        .onAppear {
            startFooterAnimation()
        }
    }
    
    private func startFooterAnimation() {
        // Запускаем анимацию футера с небольшой задержкой
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeIn(duration: 0.8)) {
                footerOpacity = 1.0
            }
        }
    }
    
    private func animateFooter() {
        withAnimation(.easeIn(duration: 0.8)) {
            footerOpacity = 1.0
        }
    }
    
    private var onboardingFooter: some View {
        VStack {
            // Индикатор страниц
            HStack(spacing: 8) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ? Color.white : Color.gray)
                        .frame(width: 8, height: 8)
                }
            }
            
            // Кнопка
            Button(action: {
                if currentPage < 2 {
                    withAnimation {
                        currentPage += 1
                    }
                } else {
                    appState.currentScreen = .main
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

// Первая страница онбординга

struct OnboardingPage1: View {
    @State private var starOpacity = 0.0
    @State private var starScale = 0.8
    @State private var starScale2 = 0.8
    @State private var starOpacity2 = 0.0
    @State private var titleOpacity = 0.0
    @State private var subtitleOpacity = 0.0
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                // Первая звезда - основная
                Image(systemName: "sparkles")
                    .font(.system(size: 80))
                    .foregroundColor(.yellow)
                    .opacity(starOpacity)
                    .scaleEffect(starScale)
                
                // Вторая звезда - дополнительная
                Image(systemName: "sparkles")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                    .opacity(starOpacity2)
                    .scaleEffect(starScale2)
                    .offset(x: 30, y: -20)
            }
            
            Text("Welcome to")
                .font(.title2)
                .foregroundColor(.white)
                .opacity(titleOpacity)
            
            Text("SPACE ADVENTURE")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.yellow)
                .opacity(titleOpacity)
            
            Text("Become the captain of your own starship and explore the galaxy")
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .opacity(subtitleOpacity)
            
            Spacer()
        }
        .onAppear {
            // 1. Появление звезд
            withAnimation(.easeIn(duration: 1.2)) {
                starOpacity = 1.0
                starOpacity2 = 1.0
            }
            
            // 2. Пульсация звезд (ограниченная по времени)
            withAnimation(.easeInOut(duration: 0.8).repeatCount(4, autoreverses: true)) {
                starScale = 1.3
                starScale2 = 1.2
            }
            
            // 3. Замирание звезд после пульсации
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                withAnimation(.easeOut(duration: 0.5)) {
                    starScale = 1.0
                    starScale2 = 1.0
                }
            }
            
            // 4. Появление текста
            withAnimation(.easeIn(duration: 0.8).delay(0.8)) {
                titleOpacity = 1.0
            }
            
            withAnimation(.easeIn(duration: 0.8).delay(1.2)) {
                subtitleOpacity = 1.0
            }
        }
    }
}

// Вторая страница онбординга
struct OnboardingPage2: View {
    @State private var planetScale = 0.5
    @State private var planetRotation = 0.0
    @State private var titleOpacity = 0.0
    @State private var subtitleOpacity = 0.0
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Анимированная планета
            Image(systemName: "globe.americas.fill")
                .font(.system(size: 100))
                .foregroundColor(.green)
                .scaleEffect(planetScale)
                .rotationEffect(.degrees(planetRotation))
            
            Text("Discover New Worlds")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .opacity(titleOpacity)
            
            Text("Each planet offers unique games and challenges. Earn stars and unlock new galaxies")
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .opacity(subtitleOpacity)
            
            Spacer()
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                planetScale = 1.0
            }
            
            withAnimation(.easeInOut(duration: 2.0)) {
                planetRotation = 360
            }
            
            withAnimation(.easeIn(duration: 0.8).delay(0.4)) {
                titleOpacity = 1.0
            }
            
            withAnimation(.easeIn(duration: 0.8).delay(0.7)) {
                subtitleOpacity = 1.0
            }
        }
    }
}

// Третья страница онбординга
struct OnboardingPage3: View {
    @State private var rocketOffset = 100.0
    @State private var rocketRotation = -45.0
    @State private var titleOpacity = 0.0
    @State private var subtitleOpacity = 0.0
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Анимированная ракета
            Image(systemName: "airplane.departure")
                .font(.system(size: 80))
                .foregroundColor(.orange)
                .rotationEffect(.degrees(rocketRotation))
                .offset(y: rocketOffset)
            
            Text("Begin Your Journey")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .opacity(titleOpacity)
            
            Text("Your starship is ready for launch. Explore, play, and become the master of the cosmos")
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .opacity(subtitleOpacity)
            
            Spacer()
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.2)) {
                rocketOffset = 0
                rocketRotation = 0
            }
            
            withAnimation(.easeIn(duration: 0.8).delay(0.5)) {
                titleOpacity = 1.0
            }
            
            withAnimation(.easeIn(duration: 0.8).delay(0.8)) {
                subtitleOpacity = 1.0
            }
        }
    }
}
