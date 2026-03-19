//
//  HomeView.swift
//  NutriTrack
//
//  Created by Baran on 19.03.2026.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = NutritionViewModel()
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(spacing: 20){
                    
                    // Kalori Özeti
                    CalorieSummaryCard(viewModel: viewModel)
                    
                    ForEach(MealEntry.MealType.allCases, id:  \.self){
                        mealType in
                        MealSectionView(
                            mealType: mealType, entries: viewModel.entries(for: mealType)
                            
                        )
                    }
                    
                }
            }
        }
    }
}

struct CalorieSummaryCard: View{
    @ObservedObject var viewModel : NutritionViewModel
    
    var body : some View{
        VStack(spacing: 16){
            Text("Günlük Kalori")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            
            Text("\(Int(viewModel.totalCalories))")
                .font(.system(size: 56, weight: .bold))
            
            Text("/ \(Int(viewModel.dailyCalorieGoal)) kcal")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            
            ProgressView(value: viewModel.calorieProgress())
                .tint(.green)
            
            HStack{
                NutrientLabel(title: "Protein", value: viewModel.totalProtein, color: .blue)
                Spacer()
                NutrientLabel(title: "Karb", value: viewModel.totalCalories, color: .orange)
                Spacer()
                NutrientLabel(title: "Yağ", value: viewModel.totalFat, color: .red)
            }
            .padding()
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.08), radius: 8)
        }
    }
}

struct NutrientLabel : View{
    let title: String
    let value : Double
    let color :Color
    
    var body : some View{
        VStack(spacing: 4){
            Text("\(Int(value))g")
                .font(.headline)
                .foregroundStyle(color)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
struct MealSectionView: View {
    
    let mealType : MealEntry.MealType
    let entries: [MealEntry]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            Text(mealType.rawValue)
                .font(.headline)
            
            if entries.isEmpty{
                Text("Henüz yemek eklenmedi")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 8)
            } else{
                ForEach(entries){ entry in
                    HStack{
                        Text(entry.foodItem.name)
                        Spacer()
                        Text("\(Int(entry.totalCalories)) kcal")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical,4)
                    
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.06),radius: 6)
    }
}



#Preview {
    HomeView()
}
