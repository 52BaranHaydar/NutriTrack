//
//  CoreDataManager.swift
//  NutriTrack
//
//  Created by Baran on 19.03.2026.
//

import Foundation
import CoreData

class CoreDataManager{
    
    static let shared = CoreDataManager()
    
    let container:NSPersistentContainer
    
    init(){
        container = NSPersistentContainer(name: "NutriTrack")
        container.loadPersistentStores { _, error in
            if let error = error{
                print("CoreData yükleme hatası: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    var context :NSManagedObjectContext{
        container.viewContext
    }
    
    // Kaydet
    func save(){
        guard context.hasChanges else { return }
        do{
            try context.save()
        } catch{
            print("CoreData kaydetme hatası: \(error)")
        }
    }
    
    // Öğün Ekle
    func addMealEntry(_ entry: MealEntry) {
        let entity = MealEntryEntity(context: context)
        entity.id = entry.id
        entity.date = entry.date
        entity.mealType = entry.mealType.rawValue
        entity.amount = entry.amount
        entity.foodName = entry.foodItem.name
        entity.calories = entry.foodItem.calories
        entity.protein = entry.foodItem.protein
        entity.fat = entry.foodItem.fat
        save()
    }
    
    // Tüm Öğünleri getir
    func fetchMealEntries() -> [MealEntry] {
        
        let request = MealEntryEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do{
            let entities = try context.fetch(request)
            return entities.compactMap{ entity in
                guard let id = entity.id,
                      let date = entity.date,
                      let mealTypeString = entity.mealType,
                      let mealType = MealEntry.MealType(rawValue: mealTypeString),
                      let foodName = entity.foodName else{ return nil }
                
                let foodItem = FoodItem(
                    id: UUID(),
                    name: foodName,
                    calories: entity.calories,
                    protein: entity.protein,
                    carbohydrates: entity.carbohydrates,
                    fat: entity.fat
                )
                
                return MealEntry(
                    id: id, foodItem: foodItem, amount: entity.amount,date: date, mealType: mealType
                )
                
            }
        } catch {
            print("CoreData okuma hatası: \(error)")
            return []
        }
    }
    
    // Öğün Sil
    
    func deleteMealEntry(_ entry: MealEntry){
        let request = MealEntryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", entry.id as CVarArg)
        
        do{
            let entities = try context.fetch(request)
            entities.forEach{ context.delete($0)}
            save()
        } catch {
            print("CoreData silme hatası: \(error)")
        }
        
        
    }
    
    
}
