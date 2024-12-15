import SwiftUI
import CoreData
import CoreLocation


struct AddListingView: View {
    private let context: NSManagedObjectContext
    private let geocoder = CLGeocoder() // For geocoding

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
                validateAddressAndPostListing()
            }
            .padding()
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .navigationTitle("Post a Parking Space")
    }

    private func validateAddressAndPostListing() {
        guard !name.isEmpty, !address.isEmpty, !location.isEmpty, !price.isEmpty else {
            alertMessage = "Please fill out all fields."
            showingAlert = true
            return
        }

        // Start geocoding the address
        geocoder.geocodeAddressString(address) { placemarks, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Address Geocoding Error: \(error.localizedDescription)")
                    alertMessage = "Invalid address: \(error.localizedDescription). Please enter a valid address."
                    showingAlert = true
                    return
                }

                // If address is valid, get coordinates
                if let addressCoordinate = placemarks?.first?.location?.coordinate {
                    print("Valid Address: \(addressCoordinate.latitude), \(addressCoordinate.longitude)")

                    // Proceed to validate the location
                    self.validateLocationAndPostListing(addressCoordinate: addressCoordinate)
                } else {
                    alertMessage = "Unable to validate address. Please enter a correct address."
                    showingAlert = true
                }
            }
        }
    }


    // MARK: - Validate Location and Post Listing
    private func validateLocationAndPostListing(addressCoordinate: CLLocationCoordinate2D) {
        // Start geocoding the location
        geocoder.geocodeAddressString(location) { placemarks, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Location Geocoding Error: \(error.localizedDescription)")
                    alertMessage = "Invalid location: \(error.localizedDescription). Please enter a valid location."
                    showingAlert = true
                    return
                }

                // If location is valid, get coordinates
                if let locationCoordinate = placemarks?.first?.location?.coordinate {
                    print("Valid Location: \(locationCoordinate.latitude), \(locationCoordinate.longitude)")

                    // Call postListing with all coordinates
                    self.postListing(
                        latitude: addressCoordinate.latitude,
                        longitude: addressCoordinate.longitude,
                        locationLatitude: locationCoordinate.latitude,
                        locationLongitude: locationCoordinate.longitude
                    )
                } else {
                    alertMessage = "Unable to validate location. Please enter a correct location."
                    showingAlert = true
                }
            }
        }
    }



    // MARK: - Post Listing with Valid Coordinates
    private func postListing(latitude: Double, longitude: Double, locationLatitude: Double, locationLongitude: Double) {
        guard let priceValue = Double(price) else {
            alertMessage = "Invalid price format. Please enter a numeric value."
            showingAlert = true
            return
        }

        let newListing = Listing(context: context)
        newListing.name = name
        newListing.address = address
        newListing.location = location
        newListing.price = price
        newListing.listingDescription = listingDescription
        newListing.latitude = latitude
        newListing.longitude = longitude
        newListing.locationLatitude = locationLatitude // Store validated location latitude
        newListing.locationLongitude = locationLongitude // Store validated location longitude

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"

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

}

