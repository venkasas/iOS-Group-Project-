//
//  AddListingViewModel.swift
//  Capstone_Project_A3
//
//  Created by Sasidurka on 2024-12-15.
//

import Foundation
import CoreData
import CoreLocation

class AddListingViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var address: String = ""
    @Published var location: String = ""
    @Published var price: String = ""
    @Published var availabilityDate: Date = Date()
    @Published var availabilityFromTime: Date = Date()
    @Published var availabilityToTime: Date = Date()
    @Published var listingDescription: String = ""
    @Published var alertMessage: String = ""
    @Published var showingAlert: Bool = false

    private let context: NSManagedObjectContext
    private let geocoder = CLGeocoder()

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func validateAndPostListing() {
        guard !name.isEmpty, !address.isEmpty, !location.isEmpty, !price.isEmpty else {
            alertMessage = "All fields must be filled out."
            showingAlert = true
            return
        }

        

//        // Geocode and validate address
//        geocodeAddress("\(address), \(location)") { isValid in
//            if isValid {
//                self.saveListing(price: priceValue)
//            } else {
//                self.alertMessage = "Invalid address or location. Please enter a valid address."
//                self.showingAlert = true
//            }
//        }
    }

    private func saveListing() {
        let newListing = Listing(context: context)
        newListing.name = name
        newListing.address = address
        newListing.location = location
        newListing.price = price
        newListing.listingDescription = listingDescription

        // Format date and time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"

        let formattedDate = dateFormatter.string(from: availabilityDate)
        let formattedFromTime = timeFormatter.string(from: availabilityFromTime)
        let formattedToTime = timeFormatter.string(from: availabilityToTime)

        newListing.availability = "\(formattedDate) from \(formattedFromTime) to \(formattedToTime)"

        do {
            try context.save()
            alertMessage = "Listing posted successfully!"
        } catch {
            alertMessage = "Failed to save listing: \(error.localizedDescription)"
        }
        showingAlert = true
    }

    private func geocodeAddress(_ fullAddress: String, completion: @escaping (Bool) -> Void) {
        geocoder.geocodeAddressString(fullAddress) { placemarks, error in
            if let error = error {
                print("Geocoding failed: \(error.localizedDescription)")
                completion(false)
                return
            }

            if let _ = placemarks?.first {
                completion(true) // Address is valid
            } else {
                completion(false) // Address invalid
            }
        }
    }
}
