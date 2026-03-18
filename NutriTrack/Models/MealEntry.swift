//
//  MealEntry.swift
//  NutriTrack
//
//  Created by Baran on 19.03.2026.
//

import Foundation

struct MealEntry : Identifiable, Codable{
    let id : UUID
    var foodItem : FoodItem
    var amount : Double
    var date: Date
    var mealType : MealType
    
    enum MealType: String,Codable, CaseIterable{
        case breakfast = "Kahvaltı"
        case lunch = "Oğle"
        case dinner = "Akşam"
        case snack = "Ara Öğün"
    }
    
    init(
        id: UUID = UUID(),
        foodItem : FoodItem,
        amount: Double,
        date : Date = Date(),
        mealType : MealType
    ) {
        self.id = id
        self.foodItem = foodItem
        self.amount = amount
        self.date = date
        self.mealType = mealType
    }
    
    var totalCalories  :Double{
        (foodItem.calories * amount) / 100
    }
    
    var totalProtein : Double{
        (foodItem.protein * amount) / 100
    }
    
    var totalCarbs: Double{
        (foodItem.carbohydrates * amount) / 100
    }
    
    var totalFat : Double{
        (foodItem.fat * amount) / 100
    }
    
    
}
