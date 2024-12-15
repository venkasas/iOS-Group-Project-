//
//  RenterReservationsViewModel.swift
//  Capstone_Project_A3
//
//  Created by Sasidurka on 2024-12-15.
//

import SwiftUI
import CoreData

class RenterReservationsViewModel: ObservableObject {
    @Published var reservedListings: [Listing] = []

    private let context: NSManagedObjectContext
    private let currentUser: String = "Current User" // Replace with actual user identifier

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchReservations()
    }

    func fetchReservations() {
        let request: NSFetchRequest<Listing> = Listing.fetchRequest()
        request.predicate = NSPredicate(format: "isBooked == true AND bookedBy == %@", currentUser)

        do {
            reservedListings = try context.fetch(request)
        } catch {
            print("Error fetching reservations: \(error.localizedDescription)")
        }
    }
}

