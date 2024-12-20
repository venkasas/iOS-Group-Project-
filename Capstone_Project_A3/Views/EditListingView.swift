//
//  EditListingView.swift
//  Capstone_Project_A3
//
//  Created by Sasidurka on 2024-10-22.
//

import SwiftUI
import CoreData

struct EditListingView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode // For navigation back
    
    @ObservedObject var listing: Listing
    
    @State private var name: String = ""
    @State private var address: String = ""
    @State private var location: String = ""
    @State private var price: String = ""
    @State private var availabilityDate: Date = Date()
    @State private var availabilityFromTime: Date = Date()
    @State private var availabilityToTime: Date = Date()
    @State private var listingDescription: String = "" // New state for description
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
//            Text("Edit Listing")
//                .font(.largeTitle)
//                .fontWeight(.bold)
//                .padding(.bottom, 8)
            
            Form {
                Section(header: Text("Listing Details")) {
                    TextField("Your Name", text: $name)
                        .padding(8)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                    TextField("Address", text: $address)
                        .padding(8)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                    TextField("Location", text: $location)
                        .padding(8)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                    TextField("Price", text: $price)
                        .keyboardType(.decimalPad)
                        .padding(8)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                    DatePicker("Date Available", selection: $availabilityDate, displayedComponents: .date)
                        .padding(8)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                    HStack {
                        DatePicker("From", selection: $availabilityFromTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                        Text("to")
                        DatePicker("To", selection: $availabilityToTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                    .padding(8)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                }
                
                Section(header: Text("Description")) {
                    TextEditor(text: $listingDescription)
                        .frame(height: 120)
                        .padding(8)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                }
            }
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding([.leading, .trailing])
            
            Button(action: saveListing) {
                Text("Save Changes")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(Color.green)
                    .cornerRadius(8)
                    .padding([.leading, .trailing, .top], 16)
            }
        }
        .padding()
        .navigationTitle("Edit Listing")
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Success"), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                presentationMode.wrappedValue.dismiss() // Navigate back on dismiss
            })
        }
        .onAppear {
            // Load listing details into form fields
            name = listing.name ?? ""
            address = listing.address ?? ""
            location = listing.location ?? ""
            price = listing.price ?? ""
            listingDescription = listing.listingDescription ?? "" // Load description
            
            // Parse availability string to extract dates and times
            if let availability = listing.availability {
                let components = availability.components(separatedBy: " ")
                if components.count >= 4 {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    if let date = dateFormatter.date(from: components[0]) {
                        availabilityDate = date
                    }
                    let timeFormatter = DateFormatter()
                    timeFormatter.dateFormat = "HH:mm:ss"
                    if let fromTime = timeFormatter.date(from: components[2]),
                       let toTime = timeFormatter.date(from: components[4]) {
                        availabilityFromTime = fromTime
                        availabilityToTime = toTime
                    }
                }
            }
        }
    }
    
    private func saveListing() {
        listing.name = name
        listing.address = address
        listing.location = location
        listing.price = price
        listing.listingDescription = listingDescription // Save description

        // Format the availability string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        
        let formattedDate = dateFormatter.string(from: availabilityDate)
        let formattedFromTime = timeFormatter.string(from: availabilityFromTime)
        let formattedToTime = timeFormatter.string(from: availabilityToTime)
        
        listing.availability = "\(formattedDate) from \(formattedFromTime) to \(formattedToTime)"
        
        do {
            try viewContext.save()
            alertMessage = "Listing updated successfully!"
            showingAlert = true
        } catch {
            alertMessage = "Failed to save changes. Please try again."
            showingAlert = true
        }
    }
}


