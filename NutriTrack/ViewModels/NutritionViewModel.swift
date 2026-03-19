//
//  NutritionViewModel.swift
//  NutriTrack
//
//  Created by Baran on 19.03.2026.
//

import Foundation
import Combine

class NutritionViewModel: ObservableObject {
    
    @Published var mealEntries: [MealEntry] = []
    @Published var selectedDate: Date = Date()
    @Published var burnedCalories: Double = 0
    
    let healthKitManager = HealthKitManager()
    let coreDataManager = CoreDataManager.shared
    
    // Günlük hedefler
    var dailyCalorieGoal: Double = 2000
    var dailyProteinGoal: Double = 150
    var dailyCarbsGoal: Double = 250
    var dailyFatGoal: Double = 65
    
    init() {
        loadMealEntries()
        Task {
            await healthKitManager.requestAuthorization()
            await fetchBurnedCalories()
        }
    }
    
    // CoreData'dan yükle
    func loadMealEntries() {
        mealEntries = coreDataManager.fetchMealEntries()
    }
    
    // Seçili güne ait öğünler
    var todayEntries: [MealEntry] {
        mealEntries.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }
    
    // Günlük toplamlar
    var totalCalories: Double {
        todayEntries.reduce(0) { $0 + $1.totalCalories }
    }
    
    var totalProtein: Double {
        todayEntries.reduce(0) { $0 + $1.totalProtein }
    }
    
    var totalCarbs: Double {
        todayEntries.reduce(0) { $0 + $1.totalCarbs }
    }
    
    var totalFat: Double {
        todayEntries.reduce(0) { $0 + $1.totalFat }
    }
    
    // Net kalori
    var netCalories: Double {
        totalCalories - burnedCalories
    }
    
    // Kalan kalori
    var remainingCalories: Double {
        dailyCalorieGoal - totalCalories
    }
    
    // Öğün ekle
    func addMealEntry(_ entry: MealEntry) {
        coreDataManager.addMealEntry(entry)
        loadMealEntries()
        Task {
            await healthKitManager.saveCalories(calories: entry.totalCalories)
            await healthKitManager.saveProtein(protein: entry.totalProtein)
        }
    }
    
    // Öğün sil
    func deleteMealEntry(_ entry: MealEntry) {
        coreDataManager.deleteMealEntry(entry)
        loadMealEntries()
    }
    
    // Öğün tipine göre filtrele
    func entries(for mealType: MealEntry.MealType) -> [MealEntry] {
        todayEntries.filter { $0.mealType == mealType }
    }
    
    // Kalori yüzdesi
    func calorieProgress() -> Double {
        min(totalCalories / dailyCalorieGoal, 1.0)
    }
    
    // Yakılan kaloriyi getir
    func fetchBurnedCalories() async {
        let burned = await healthKitManager.fetchBurnedCalories()
        await MainActor.run {
            self.burnedCalories = burned
        }
    }
}
