//
//  DataService.swift
//  SpaceMiniGames
//
//  Created by Илья Лысенко on 08.10.2025.
//

import Foundation

class DataService {
    private let userDefaults = UserDefaults.standard
    
    // Ключи для сохранения
    private let userKey = "savedUser"
    private let hasCompletedOnboardingKey = "hasCompletedOnboarding"
    
    // Сохраняем пользователя
  /* func saveUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            userDefaults.set(encoded, forKey: userKey)
            print("💾 User data saved")
        }
    } */
    
    // Загружаем пользователя
    func loadUser() -> User {
        if let savedUserData = userDefaults.data(forKey: userKey),
           let decodedUser = try? JSONDecoder().decode(User.self, from: savedUserData) {
            print("📂 User data loaded")
            return decodedUser
        } else {
            print("📂 New user created")
            return User() // Возвращаем нового пользователя если нет сохраненных данных
        }
    }
    
    // Сохраняем статус онбординга
    func saveOnboardingStatus(_ completed: Bool) {
        userDefaults.set(completed, forKey: hasCompletedOnboardingKey)
        print("💾 Onboarding status saved: \(completed)")
    }
    
    // Проверяем статус онбординга
    func loadOnboardingStatus() -> Bool {
        return userDefaults.bool(forKey: hasCompletedOnboardingKey)
    }
    
    // Очистка всех данных (для тестирования)
    func clearAllData() {
        userDefaults.removeObject(forKey: userKey)
        userDefaults.removeObject(forKey: hasCompletedOnboardingKey)
        print("🗑️ All data cleared")
    }
    
    func saveUser(_ user: User) {
        do {
            let encoded = try JSONEncoder().encode(user)
            userDefaults.set(encoded, forKey: userKey)
            print("💾 User data saved successfully")
            
            // Проверим что сохранилось
            if let savedData = userDefaults.data(forKey: userKey),
               let testUser = try? JSONDecoder().decode(User.self, from: savedData) {
                print("✅ Verify saved: '\(testUser.username)', onboarding: \(testUser.hasCompletedOnboarding)")
            }
        } catch {
            print("❌ Failed to save user: \(error)")
        }
    }
}
