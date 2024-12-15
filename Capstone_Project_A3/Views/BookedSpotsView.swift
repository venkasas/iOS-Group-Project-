import SwiftUI
import CoreData

struct BookedSpotsView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: ParkingSpot.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ParkingSpot.spotNumber, ascending: true)],
        predicate: NSPredicate(format: "isBooked == true")
    ) private var bookedSpots: FetchedResults<ParkingSpot>

    var body: some View {
        NavigationView {
            List {
                if bookedSpots.isEmpty {
                    Text("No booked spots available.")
                        .foregroundColor(.gray)
                        .italic()
                } else {
                    ForEach(bookedSpots) { spot in
                        NavigationLink(destination: BookedSpotDetailView(spot: spot)) {
                            VStack(alignment: .leading) {
                                Text("Spot \(spot.spotNumber ?? "Unknown")")
                                    .font(.headline)

                                Text("Booked")
                                    .foregroundColor(.red)
                                    .font(.subheadline)
                                
                                Text("Booking Date: \(formattedDate(spot.bookingDate))")
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Booked Spots")
        }
    }

    private func formattedDate(_ date: Date?) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        if let date = date {
            return formatter.string(from: date)
        } else {
            return "Unknown Date"
        }
    }
}

struct BookedSpotDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var spot: ParkingSpot

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Details for Spot \(spot.spotNumber ?? "Unknown")")
                .font(.title)
                .fontWeight(.bold)

            if let bookingDate = spot.bookingDate {
                Text("Booking Date: \(formattedLongDate(bookingDate))")
                    .font(.subheadline)
            }

            Spacer()

            Button(action: deleteReservation) {
                Text("Delete Reservation")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(Color.red)
                    .cornerRadius(8)
                    .padding()
            }
        }
        .padding()
        .navigationTitle("Spot Reservation Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func formattedLongDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private func deleteReservation() {
        viewContext.delete(spot)

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Failed to delete reservation: \(error)")
        }
    }
}

struct BookedSpotsView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        return BookedSpotsView().environment(\.managedObjectContext, context)
    }
}
