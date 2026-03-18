//
//  NutriTrackApp.swift
//  NutriTrack
//
//  Created by Baran on 18.03.2026.
//

import SwiftUI
import CoreData

@main
struct NutriTrackApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
