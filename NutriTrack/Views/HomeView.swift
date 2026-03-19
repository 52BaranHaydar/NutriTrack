//
//  HomeView.swift
//  NutriTrack
//
//  Created by Baran on 19.03.2026.
//
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = NutritionViewModel()
    @State private var showFoodSearch = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    CalorieSummaryCard(viewModel: viewModel)
                    
                    ForEach(MealEntry.MealType.allCases, id: \.self) { mealType in
                        MealSectionView(
                            mealType: mealType,
                            entries: viewModel.entries(for: mealType),
                            onDelete: { entry in
                                viewModel.deleteMealEntry(entry)
                            }
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("NutriTrack")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showFoodSearch = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.green)
                    }
                }
            }
            .sheet(isPresented: $showFoodSearch) {
                FoodSearchView(viewModel: viewModel)
            }
        }
    }
}

struct CalorieSummaryCard: View {
    @ObservedObject var viewModel: NutritionViewModel
    
    var body: some View {
        VStack(spacing: 16) {
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
                VStack(spacing : 4){
                    Text("\(Int(viewModel.burnedCalories))")
                        .font(.headline)
                        .foregroundStyle(.orange)
                    Text("Yakılan")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                VStack(spacing: 4) {
                    Text("\(Int(viewModel.remainingCalories))")
                        .font(.headline)
                        .foregroundStyle(viewModel.remainingCalories >= 0 ? .green : .red)
                    Text("Kalan")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            HStack {
                NutrientLabel(title: "Protein", value: viewModel.totalProtein, color: .blue)
                Spacer()
                NutrientLabel(title: "Karb", value: viewModel.totalCarbs, color: .orange)
                Spacer()
                NutrientLabel(title: "Yağ", value: viewModel.totalFat, color: .red)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 8)
    }
}

struct NutrientLabel: View {
    let title: String
    let value: Double
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
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
    let mealType: MealEntry.MealType
    let entries: [MealEntry]
    let onDelete: (MealEntry) -> Void
    
    var totalCalories: Double {
        entries.reduce(0) { $0 + $1.totalCalories }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(mealType.rawValue)
                    .font(.headline)
                Spacer()
                if !entries.isEmpty {
                    Text("\(Int(totalCalories)) kcal")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            if entries.isEmpty {
                Text("Henüz yemek eklenmedi")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 8)
            } else {
                ForEach(entries) { entry in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(entry.foodItem.name)
                                .font(.subheadline)
                            Text("\(Int(entry.amount))g")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text("\(Int(entry.totalCalories)) kcal")
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                        
                        Button {
                            onDelete(entry)
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(.red)
                                .font(.caption)
                        }
                    }
                    .padding(.vertical, 4)
                    Divider()
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.06), radius: 6)
    }
}

#Preview {
    HomeView()
}
