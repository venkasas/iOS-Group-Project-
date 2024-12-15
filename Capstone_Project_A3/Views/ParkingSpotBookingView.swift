//import SwiftUI
//import CoreData
//
//
//struct ParkingSpotBookingView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//    
//    @FetchRequest(
//        entity: ParkingSpot.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \ParkingSpot.spotNumber, ascending: true)]
//    ) private var parkingSpots: FetchedResults<ParkingSpot>
//
//    @State private var selectedSpot: ParkingSpot?
//    @State private var bookingDate = Date()
//    @State private var showAlert = false
//    @State private var showBookedSpots = false
//    @State private var showMenu = false
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text("Book a Parking Spot")
//                    .font(.largeTitle)
//                    .padding()
//
//                List {
//                    ForEach(parkingSpots) { spot in
//                        VStack(alignment: .leading) {
//                            HStack {
//                                Text("Spot \(spot.spotNumber ?? "Unknown")")
//                                    .font(.headline)
//
//                                Spacer()
//
//                                if spot.isBooked {
//                                    Text("Booked")
//                                        .foregroundColor(.red)
//                                        .font(.subheadline)
//                                } else {
//                                    Button("Select") {
//                                        selectedSpot = spot
//                                    }
//                                    .buttonStyle(BorderlessButtonStyle())
//                                }
//                            }
//
//                            if spot.isBooked {
//                                Text("Booking Date: \(formattedDate(spot.bookingDate))")
//                                    .font(.caption)
//                            } else {
//                                Text("Available for booking")
//                                    .foregroundColor(.green)
//                                    .font(.subheadline)
//                            }
//                        }
//                        .padding()
//                    }
//                    .onDelete(perform: deleteSpots)
//                }
//
//                DatePicker("Select Booking Date:", selection: $bookingDate, displayedComponents: .date)
//                    .padding()
//
//                Button("Confirm Booking") {
//                    bookSpot()
//                }
//                .disabled(selectedSpot == nil)
//                .padding()
//                .alert(isPresented: $showAlert) {
//                    Alert(title: Text("Success"), message: Text("Parking spot booked!"), dismissButton: .default(Text("OK")))
//                }
//            }
//            .navigationTitle("Parking Booking")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button(action: {
//                        showMenu = true
//                    }) {
//                        Image(systemName: "line.horizontal.3")
//                    }
//                }
//            }
//            .actionSheet(isPresented: $showMenu) {
//                ActionSheet(
//                    title: Text("Menu"),
//                    buttons: [
//                        .default(Text("View Booked Spots")) {
//                            showBookedSpots = true
//                        },
//                        .cancel()
//                    ]
//                )
//            }
//            .sheet(isPresented: $showBookedSpots) {
//                BookedSpotsView().environment(\.managedObjectContext, viewContext)
//            }
//        }
//    }
//
//    private func bookSpot() {
//        guard let spot = selectedSpot else { return }
//
//        spot.isBooked = true
//        spot.bookingDate = bookingDate
//
//        do {
//            try viewContext.save()
//            showAlert = true
//        } catch {
//            print("Error saving booking: \(error.localizedDescription)")
//        }
//    }
//
//    private func deleteSpots(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { parkingSpots[$0] }.forEach(viewContext.delete)
//            
//            do {
//                try viewContext.save()
//                print("Spot(s) deleted successfully.")
//            } catch {
//                print("Failed to delete spot: \(error)")
//            }
//        }
//    }
//
//    // Function to format the date
//    private func formattedDate(_ date: Date?) -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//        if let date = date {
//            return formatter.string(from: date)
//        } else {
//            return "Unknown Date"
//        }
//    }
//}
//
//
////struct ParkingSpotBookingView_Previews: PreviewProvider {
////    static var previews: some View {
////        let context = PersistenceController.shared.container.viewContext
////        return ParkingSpotBookingView().environment(\.managedObjectContext, context)
////    }
////}
