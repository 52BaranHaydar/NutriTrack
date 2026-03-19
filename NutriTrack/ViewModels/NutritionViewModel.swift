//
//  NutritionViewModel.swift
//  NutriTrack
//
//  Created by Baran on 19.03.2026.
//

import Foundation
import Combine

class NutritionViewModel: ObservableObject{
    
    @Published var mealEntries: [MealEntry] = []
    @Published var selectedDate : Date = Date()
    
    // Günlük hedefler
    var dailyCalorieGoal : Double = 2000
    var dailyProteinGoal : Double = 150
    var dailyCarbsGoal :Double = 250
    var dailyFatGoal : Double = 65
    
    // Seçili güne ait öğünle
    var todayEntries : [MealEntry] {
        mealEntries.filter{
            Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
        }
    }
    
    // Günlük toplamlar
    
    var totalCalories: Double{
        todayEntries.reduce(0){
            $0 + $1.totalCalories
        }
    }
    
    var totalProtein : Double{
        todayEntries.reduce(0) {
            $0 + $1.totalProtein
        }
    }
    
    var totalCarbs :Double {
        todayEntries.reduce(0) {
            $0 + $1.totalCarbs
        }
    }
    
    var totalFat: Double {
        todayEntries.reduce(0){
            $0 + $1.totalFat
        }
    }
    // Kalan Kalori
    var remainingCalories : Double{
        dailyCalorieGoal - totalCalories
    }
    // Öğün Ekle
    func addMealEntry(_ entry: MealEntry){
        mealEntries.append(entry)
    }
    // Öğün Sil
    func deleteMealEntry(_ entry : MealEntry){
        mealEntries.removeAll(){
            $0.id == entry.id
        }
    }
    // Öğün tipine göre filtrele
    func entries(for mealType: MealEntry.MealType) -> [MealEntry]{
        todayEntries.filter{
            $0.mealType == mealType
        }
    }
    // Kalori Yüzdesi
    func calorieProgress() -> Double{
        min(totalCalories / dailyCalorieGoal, 1.0)
    }
    
    
    
    
}
