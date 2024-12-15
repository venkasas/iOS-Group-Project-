//
//  RenterListingsViewModel.swift
//  Capstone_Project_A3
//
//  Created by Sasidurka on 2024-12-15.
//

import Foundation
import SwiftUI
import CoreData

class RenterListingsViewModel: ObservableObject {
    @Published var listings: [Listing] = []
    @Published var showingAlert: Bool = false
    @Published var alertMessage: String = ""

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchListings()
    }

    func fetchListings() {
        let request: NSFetchRequest<Listing> = Listing.fetchRequest()
        
        do {
            let allListings = try context.fetch(request)
            self.listings = allListings.filter { !$0.isBooked } // Show only unbooked listings
        } catch {
            print("Failed to fetch listings: \(error.localizedDescription)")
        }
    }

    func bookListing(listing: Listing) {
        listing.isBooked = true
        listing.bookedBy = "Current User" 
        listing.bookingDate = Date()

        do {
            try context.save()
            alertMessage = "Parking space booked successfully!"
            showingAlert = true
            fetchListings() // Refresh listings
        } catch {
            alertMessage = "Failed to book the parking space. Please try again."
            showingAlert = true
        }
    }
}
