//
//  HealthKitManager.swift
//  NutriTrack
//
//  Created by Baran on 19.03.2026.
//

import Foundation
import HealthKit
import Combine

class HealthKitManager: ObservableObject {
    
    private let healthStore = HKHealthStore()
    
    @Published var isAuthorized = false
    
    // Yazma ve okuma izinleri
    let writeTypes: Set<HKSampleType> = [
        HKQuantityType(.dietaryEnergyConsumed),
        HKQuantityType(.dietaryProtein),
        HKQuantityType(.dietaryCarbohydrates),
        HKQuantityType(.dietaryFatTotal)
    ]
    
    let readTypes: Set<HKObjectType> = [
        HKQuantityType(.dietaryEnergyConsumed),
        HKQuantityType(.dietaryProtein),
        HKQuantityType(.dietaryCarbohydrates),
        HKQuantityType(.dietaryFatTotal),
        HKQuantityType(.activeEnergyBurned),
        HKQuantityType(.stepCount)
    ]
    
    func requestAuthorization() async {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        do {
            try await healthStore.requestAuthorization(toShare: writeTypes, read: readTypes)
            await MainActor.run {
                self.isAuthorized = true
            }
        } catch {
            print("HealthKit izin hatası: \(error)")
        }
    }
    // Apple Health'e kalori kaydet
    func saveCalories(calories : Double, date: Date = Date()) async {
        let calorieType = HKQuantityType(.dietaryEnergyConsumed)
        let calorieQuantitity = HKQuantity(unit: .kilocalorie(), doubleValue: calories)
        let sample = HKQuantitySample(
            type: calorieType, quantity: calorieQuantitity, start: date, end: date
        )
        
        do{
            try await healthStore.save(sample)
            print("Kalori kaydedildi: \(calories) kcal")
        } catch{
            print("Kalori kaydetme hatası: \(error)")
        }
        
    }
    func saveProtein(protein  :Double, date : Date = Date()) async {
        
        let proteinType = HKQuantityType(.dietaryProtein)
        let proteinQuantity = HKQuantity(unit: .gram(), doubleValue: protein)
        let sample = HKQuantitySample(
            type: proteinType, quantity: proteinQuantity, start: date, end: date
        )
        
        do {
            try await healthStore.save(sample)
            print("Protein kaydedildi: \(protein)g")
        } catch{
            print("Protein kaydetme hatası: \(error)")
        }
    }
    
    func fetchBurnedCalories(date: Date = Date()) async -> Double {
        let burnedType = HKQuantityType(.activeEnergyBurned)
        let startOfDay = Calendar.current.startOfDay(for: date)
        let predicate  = HKQuery.predicateForSamples(withStart: startOfDay, end: date)
        
        return await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(
                quantityType: burnedType, quantitySamplePredicate: predicate, options: .cumulativeSum
            ) {
                _, statistics , _ in
                let value = statistics?.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
                continuation.resume(returning: value)
            }
            self.healthStore.execute(query)
        }
        
        
        
    }

    
    
    
}
