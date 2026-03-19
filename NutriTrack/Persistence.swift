//
//  Persistence.swift
//  NutriTrack
//
//  Created by Baran on 18.03.2026.
//
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "NutriTrack")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("CoreData hata: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
