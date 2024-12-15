//
//  BookingService.swift
//  Capstone_Project_A3
//
//  Created by manpreet kaur on 2024-12-12.
//

import CoreData
import SwiftUI

class BookingService {
    
    // Function to book a parking space
    static func bookListing(
        listing: Listing,
        viewContext: NSManagedObjectContext,
        alertMessage: Binding<String>,
        showingAlert: Binding<Bool>
    ) {
        // Check if the listing is already booked
        if listing.isBooked {
            alertMessage.wrappedValue = "This listing is already booked."
            showingAlert.wrappedValue = true
            return
        }

        // Perform the booking
        listing.isBooked = true
        listing.bookedBy = "Current User" // Replace with actual user info
        listing.bookingDate = Date()

        do {
            // Save the changes to Core Data
            try viewContext.save()
            alertMessage.wrappedValue = "Parking space booked successfully!"
        } catch {
            alertMessage.wrappedValue = "Failed to book parking space."
        }

        showingAlert.wrappedValue = true
    }
}
