//
//  ListingViewModel.swift
//  Capstone_Project_A3
//
//  Created by Sasidurka on 2024-12-12.
//

import Foundation
import SwiftUI
import CoreData
import Combine
import CoreLocation

class ListingViewModel: ObservableObject {
    @Published var listings: [Listing] = []
    @Published var alertMessage: String = ""
    @Published var showingAlert: Bool = false
    @Published var geocodedAddress: String = ""

    private let context: NSManagedObjectContext
    private let geocoder = CLGeocoder()

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

    func addListing(
        name: String, address: String, location: String,
        price: String, availability: String, description: String
    ) {
        let newListing = Listing(context: context)
        newListing.name = name
        newListing.address = address
        newListing.location = location
        newListing.price = price
        newListing.availability = availability
        newListing.listingDescription = description
        newListing.timestamp = Date()

        saveContext()
    }

    func deleteListing(_ listing: Listing) {
        context.delete(listing)
        saveContext()
    }

    func updateListing(_ listing: Listing, updatedFields: [String: Any]) {
        updatedFields.forEach { key, value in
            listing.setValue(value, forKey: key)
        }
        saveContext()
    }

    func saveContext() {
        do {
            try context.save()
            fetchListings()
        } catch {
            alertMessage = "Failed to save data: \(error.localizedDescription)"
            showingAlert = true
        }
    }

    func validateAddress(_ address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
            geocoder.geocodeAddressString(address) { placemarks, error in
                if let error = error {
                    self.alertMessage = "Invalid Address: \(error.localizedDescription)"
                    self.showingAlert = true
                    completion(nil)
                    return
                }
                
                if let coordinate = placemarks?.first?.location?.coordinate {
                    // Valid address, return the coordinates
                    completion(coordinate)
                } else {
                    self.alertMessage = "Could not find a valid location for the entered address."
                    self.showingAlert = true
                    completion(nil)
                }
            }
        }
}

