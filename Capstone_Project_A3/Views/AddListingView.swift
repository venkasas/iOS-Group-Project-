import SwiftUI
import CoreData

struct AddListingView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: ListingViewModel

    @State private var name: String = ""
    @State private var address: String = ""
    @State private var location: String = ""
    @State private var price: String = ""
    @State private var availabilityDate: Date = Date()
    @State private var availabilityFromTime: Date = Date()
    @State private var availabilityToTime: Date = Date()
    @State private var listingDescription: String = ""

    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: ListingViewModel(context: context))
    }

    var body: some View {
        VStack {
            Form {
                TextField("Your Name", text: $name)
                TextField("Address", text: $address)
                TextField("Location", text: $location)
                TextField("Price", text: $price).keyboardType(.decimalPad)
                DatePicker("Date Available", selection: $availabilityDate, displayedComponents: .date)
                DatePicker("From Time", selection: $availabilityFromTime, displayedComponents: .hourAndMinute)
                DatePicker("To Time", selection: $availabilityToTime, displayedComponents: .hourAndMinute)
                TextField("Description", text: $listingDescription)
            }

            Button("Geocode Address") {
                viewModel.geocodeAddress(address: address)
            }
            .padding()
            .alert(isPresented: $viewModel.showingAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }

            Button("Post Listing") {
                let availability = "\(availabilityDate) from \(availabilityFromTime) to \(availabilityToTime)"
                viewModel.addListing(
                    name: name,
                    address: address,
                    location: viewModel.geocodedAddress,
                    price: price,
                    availability: availability,
                    description: listingDescription
                )
            }
            .padding()
        }
        .navigationTitle("Post a Parking Space")
    }
}
