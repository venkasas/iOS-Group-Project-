//
//  RenterReservationsView.swift
//  Capstone_Project_A3
//
//  Created by Sasidurka on 2024-12-15.
//  Where the renter can view their parking spots revervations

import SwiftUI
import CoreData

struct RenterReservationsView: View {
    @StateObject private var viewModel: RenterReservationsViewModel

    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: RenterReservationsViewModel(context: context))
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.reservedListings) { listing in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(listing.name ?? "Unknown Name")
                            .font(.headline)
                        Text("Location: \(listing.address ?? "Unknown Address")")
                            .font(.subheadline)
                        Text("Price: \(listing.price ?? "N/A")")
                            .font(.caption)
                        Text("Reserved On: \(formattedDate(listing.bookingDate))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(8)
                }
            }
            //.navigationTitle("My Reservations")
            .onAppear {
                viewModel.fetchReservations()
            }
        }
    }

    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

