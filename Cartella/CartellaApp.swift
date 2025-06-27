//
//  CartellaApp.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-27.
//

import SwiftUI

@main
struct CartellaApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
