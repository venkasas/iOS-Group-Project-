//
//  RenterListingsView.swift
//  Capstone_Project_A3
//
//  Created by Sasidurka on 2024-12-15.
//

import SwiftUI
import CoreData

struct RenterListingsView: View {
    @StateObject private var viewModel: RenterListingsViewModel
    
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: RenterListingsViewModel(context: context))
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.listings) { listing in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(listing.name ?? "Unknown Name")
                            .font(.headline)
                        
                        Text("Location: \(listing.location ?? "Unknown Address")")
                            .font(.subheadline)
                        
                        Text("Address: \(listing.address ?? "Unknown Address")")
                            .font(.subheadline)
                        
                        if let price = listing.price as? Double {
                            Text("Price: $\(String(format: "%.2f", price))")
                                .font(.caption)
                        } else {
                            Text("Price: Unknown")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        // Display formatted availability
                        if let availability = listing.availability {
                            Text("Available: \(formatAvailability(availability))")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        
                        if !listing.isBooked {
                            Button(action: {
                                viewModel.bookListing(listing: listing)
                            }) {
                                Text("Book Now")
                                    .foregroundColor(.blue)
                            }
                        } else {
                            Text("Already Booked")
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                    }
                    .padding(5)
                }
            }
            //.navigationTitle("Available Listings")
            .alert(isPresented: $viewModel.showingAlert) {
                Alert(title: Text("Message"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    // MARK: - Helper Functions

    // Function to format the availability string
    private func formatAvailability(_ availability: String) -> String {
        // Example input: "2024-12-15 from 15:49:36 to 18:49:36"
        let components = availability.components(separatedBy: " ")
        if components.count >= 5 {
            let dateStr = components[0]
            let fromTimeStr = components[2]
            let toTimeStr = components[4]

            let formattedDate = formatDate(dateStr)
            let formattedFromTime = formatTime(fromTimeStr)
            let formattedToTime = formatTime(toTimeStr)

            return "\(formattedDate) from \(formattedFromTime) to \(formattedToTime)"
        }
        return availability // Return raw string if parsing fails
    }

    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString) {
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
        return dateString
    }

    private func formatTime(_ timeString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.timeZone = TimeZone.current
        if let time = formatter.date(from: timeString) {
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            return formatter.string(from: time)
        }
        return timeString
    }
}
