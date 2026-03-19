//
//  FoodSearchView.swift
//  NutriTrack
//
//  Created by Baran on 19.03.2026.
//
import SwiftUI

struct FoodSearchView: View {
    @ObservedObject var viewModel: NutritionViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchText = ""
    @State private var selectedMealType: MealEntry.MealType = .breakfast
    @State private var amount: String = "100"
    @State private var selectedFood: FoodItem?
    
    // Örnek yiyecekler (ileride API'dan gelecek)
    let sampleFoods: [FoodItem] = [
        FoodItem(name: "Yumurta", calories: 155, protein: 13, carbohydrates: 1.1, fat: 11),
        FoodItem(name: "Tavuk Göğsü", calories: 165, protein: 31, carbohydrates: 0, fat: 3.6),
        FoodItem(name: "Pirinç", calories: 130, protein: 2.7, carbohydrates: 28, fat: 0.3),
        FoodItem(name: "Ekmek", calories: 265, protein: 9, carbohydrates: 49, fat: 3.2),
        FoodItem(name: "Elma", calories: 52, protein: 0.3, carbohydrates: 14, fat: 0.2),
        FoodItem(name: "Muz", calories: 89, protein: 1.1, carbohydrates: 23, fat: 0.3),
        FoodItem(name: "Süt", calories: 42, protein: 3.4, carbohydrates: 5, fat: 1),
        FoodItem(name: "Yoğurt", calories: 59, protein: 3.5, carbohydrates: 3.6, fat: 3.3),
        FoodItem(name: "Zeytinyağı", calories: 884, protein: 0, carbohydrates: 0, fat: 100),
        FoodItem(name: "Mercimek", calories: 116, protein: 9, carbohydrates: 20, fat: 0.4),
    ]
    
    var filteredFoods: [FoodItem] {
        if searchText.isEmpty {
            return sampleFoods
        }
        return sampleFoods.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                // Öğün tipi seçici
                Picker("Öğün", selection: $selectedMealType) {
                    ForEach(MealEntry.MealType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                // Seçili yemek varsa miktar girişi
                if let food = selectedFood {
                    VStack(spacing: 12) {
                        HStack {
                            Text(food.name)
                                .font(.headline)
                            Spacer()
                            Button {
                                selectedFood = nil
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        HStack {
                            Text("Miktar (g):")
                            TextField("100", text: $amount)
                                .keyboardType(.numberPad)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 100)
                            
                            Spacer()
                            
                            if let amountDouble = Double(amount) {
                                Text("\(Int(food.calories * amountDouble / 100)) kcal")
                                    .foregroundStyle(.green)
                                    .font(.headline)
                            }
                        }
                        
                        Button {
                            addFood(food)
                        } label: {
                            Text("Ekle")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                }
                
                // Yemek listesi
                List(filteredFoods) { food in
                    Button {
                        selectedFood = food
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(food.name)
                                    .foregroundStyle(.primary)
                                    .font(.headline)
                                Text("P: \(Int(food.protein))g · K: \(Int(food.carbohydrates))g · Y: \(Int(food.fat))g")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text("\(Int(food.calories)) kcal")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .searchable(text: $searchText, prompt: "Yemek ara...")
            }
            .navigationTitle("Yemek Ekle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") { dismiss() }
                }
            }
        }
    }
    
    func addFood(_ food: FoodItem) {
        guard let amountDouble = Double(amount), amountDouble > 0 else { return }
        let entry = MealEntry(
            foodItem: food,
            amount: amountDouble,
            mealType: selectedMealType
        )
        viewModel.addMealEntry(entry)
        dismiss()
    }
}

#Preview {
    FoodSearchView(viewModel: NutritionViewModel())
}
