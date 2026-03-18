//
//  FoodItem.swift
//  NutriTrack
//
//  Created by Baran on 19.03.2026.
//

import Foundation

struct FoodItem:Identifiable, Codable{
    
    let id :UUID
    var name:String
    var calories :Double
    var protein:Double
    var carbohydrates : Double
    var fat :Double
    var servingSize : Double
    var servingUnit : String
    
    
    init(
        id : UUID = UUID(),
        name : String,
        calories : Double,
        protein : Double,
        carbohydrates : Double,
        fat :Double,
        servingSize : Double = 100,
        servingUnit :String = "g"
    ) {
        self.id = id
        self.name = name
        self.calories = calories
        self.protein = protein
        self.carbohydrates = carbohydrates
        self.fat = fat
        self.servingSize = servingSize
        self.servingUnit = servingUnit
    }
    
}
