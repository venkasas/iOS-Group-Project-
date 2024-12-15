//
//  ContentView.swift
//  Capstone_Project_A3
//
//  Created by Sasidurka on 2024-10-22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    var body: some View {
        NavigationView {
            AddListingView(context: context)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        ContentView(context: context)
            .environment(\.managedObjectContext, context)
    }
}

