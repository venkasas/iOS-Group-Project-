import SwiftUI
import CoreData

struct AddListingView: View {
    private let context: NSManagedObjectContext

    @State private var name: String = ""
    @State private var address: String = ""
    @State private var location: String = ""
    @State private var price: String = ""
    @State private var availabilityDate: Date = Date()
    @State private var availabilityFromTime: Date = Date()
    @State private var availabilityToTime: Date = Date()
    @State private var listingDescription: String = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    var body: some View {
        VStack {
            Form {
                TextField("Your Name", text: $name)
                TextField("Address", text: $address)
                TextField("Location", text: $location)
                TextField("Price", text: $price).keyboardType(.decimalPad)
                DatePicker("Date Available", selection: $availabilityDate, displayedComponents: .date)
                HStack {
                    DatePicker("From Time", selection: $availabilityFromTime, displayedComponents: .hourAndMinute)
                    Text("to")
                    DatePicker("To Time", selection: $availabilityToTime, displayedComponents: .hourAndMinute)
                }
                TextField("Description", text: $listingDescription)
            }

            Button("Post Listing") {
                postListing()
            }
            .padding()
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .navigationTitle("Post a Parking Space")
    }

    private func postListing() {
        guard !name.isEmpty, !address.isEmpty, !price.isEmpty else {
            alertMessage = "Please fill out all fields."
            showingAlert = true
            return
        }

        let newListing = Listing(context: context)
        newListing.name = name
        newListing.address = address
        newListing.location = location
        newListing.price = price
        newListing.listingDescription = listingDescription
        newListing.availability = "\(availabilityDate) from \(availabilityFromTime) to \(availabilityToTime)"

        do {
            try context.save()
            alertMessage = "Listing posted successfully!"
        } catch {
            alertMessage = "Failed to save listing: \(error.localizedDescription)"
        }
        showingAlert = true
    }
}
