//
//  Capstone_Project_A3App.swift
//  Capstone_Project_A3
//
//  Created by Sasidurka on 2024-10-22.
//

import SwiftUI

@main
struct Capstone_Project_A3App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}





