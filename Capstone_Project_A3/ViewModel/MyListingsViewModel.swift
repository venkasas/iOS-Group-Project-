//
//  ViewListingViewModel.swift
//  Capstone_Project_A3
//
//  Created by Sasidurka on 2024-12-15.
//

import CoreData
import SwiftUI

class MyListingsViewModel: ObservableObject {
    @Published var listings: [Listing] = []
    @Published var alertMessage: String = ""
    @Published var showingAlert: Bool = false

    private(set) var context: NSManagedObjectContext // Exposed read-only access to context

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchListings()
    }

    func fetchListings() {
        let fetchRequest: NSFetchRequest<Listing> = Listing.fetchRequest()
        do {
            listings = try context.fetch(fetchRequest)
        } catch {
            alertMessage = "Failed to fetch listings: \(error.localizedDescription)"
            showingAlert = true
        }
    }

    func deleteListing(at offsets: IndexSet) {
        offsets.forEach { index in
            let listing = listings[index]
            context.delete(listing)
        }
        saveContext()
    }

    private func saveContext() {
        do {
            try context.save()
            fetchListings()
        } catch {
            alertMessage = "Failed to save data: \(error.localizedDescription)"
            showingAlert = true
        }
    }
}
