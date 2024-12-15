//
//  EditListingViewModel.swift
//  Capstone_Project_A3
//
//  Created by Sasidurka on 2024-12-15.
//

import Foundation
import SwiftUI
import CoreData

class EditListingViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var address: String = ""
    @Published var location: String = ""
    @Published var price: String = ""
    @Published var availabilityDate: Date = Date()
    @Published var availabilityFromTime: Date = Date()
    @Published var availabilityToTime: Date = Date()
    @Published var description: String = ""
    @Published var alertMessage: String = ""
    @Published var showingAlert: Bool = false

    private let context: NSManagedObjectContext
    private let listing: Listing

    init(context: NSManagedObjectContext, listing: Listing) {
        self.context = context
        self.listing = listing
        loadData()
    }

    func loadData() {
        name = listing.name ?? ""
        address = listing.address ?? ""
        location = listing.location ?? ""
        price = listing.price ?? ""
        description = listing.listingDescription ?? ""

        // Parse availability date and time
        if let availability = listing.availability {
            let components = availability.components(separatedBy: " ")
            if components.count >= 5 {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                if let date = dateFormatter.date(from: components[0]) {
                    availabilityDate = date
                }

                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "h:mm a"
                if let fromTime = timeFormatter.date(from: components[2]) {
                    availabilityFromTime = fromTime
                }
                if let toTime = timeFormatter.date(from: components[4]) {
                    availabilityToTime = toTime
                }
            }
        }
    }

    func saveChanges() {
//        guard let priceValue = Double(price) else {
//            alertMessage = "Invalid price format."
//            showingAlert = true
//            return
//        }

        listing.name = name
        listing.address = address
        listing.location = location
        listing.price = price
        listing.listingDescription = description

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"

        let formattedDate = dateFormatter.string(from: availabilityDate)
        let formattedFromTime = timeFormatter.string(from: availabilityFromTime)
        let formattedToTime = timeFormatter.string(from: availabilityToTime)

        listing.availability = "\(formattedDate) from \(formattedFromTime) to \(formattedToTime)"

        saveContext()
    }

    private func saveContext() {
        do {
            try context.save()
            alertMessage = "Listing updated successfully!"
        } catch {
            alertMessage = "Failed to save changes: \(error.localizedDescription)"
        }
        showingAlert = true
    }
}
