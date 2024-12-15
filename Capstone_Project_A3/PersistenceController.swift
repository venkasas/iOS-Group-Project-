// PersistenceController.swift
//  Capstone_Project_A3
//
//  Created by Sasidurka on 2024-10-22.

// PersistenceController.swift
//  Capstone_Project_A3
//
//  Created by Sasidurka on 2024-10-22.

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Capstone_Project_A3")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        preloadParkingSpots(context: container.viewContext)
        setupMockData(context: container.viewContext) // Ensure mock data is set up after loading stores
    }

    // Mock Data Setup Function
    func setupMockData(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Listing> = Listing.fetchRequest()
        do {
            let existingListings = try context.fetch(fetchRequest)
            if !existingListings.isEmpty {
                print("Mock data already exists. Skipping setup.")
                return
            }

            print("Setting up mock data...")

            // Create booked listings
            let bookedListing1 = Listing(context: context)
            bookedListing1.name = "Downtown Parking Spot"
            bookedListing1.location = "Downtown"
            bookedListing1.address = "123 Main St"
            bookedListing1.price = "20"
            bookedListing1.isBooked = true
            bookedListing1.bookedBy = "John Doe"
            bookedListing1.bookingDate = Date()

            let bookedListing2 = Listing(context: context)
            bookedListing2.name = "Uptown Garage"
            bookedListing2.location = "Uptown"
            bookedListing2.address = "456 Elm St"
            bookedListing2.price = "15"
            bookedListing2.isBooked = true
            bookedListing2.bookedBy = "Jane Smith"
            bookedListing2.bookingDate = Date()

            // Create an unbooked listing
            let unbookedListing = Listing(context: context)
            unbookedListing.name = "Suburban Parking Lot"
            unbookedListing.location = "Suburbia"
            unbookedListing.address = "789 Oak St"
            unbookedListing.price = "10"
            unbookedListing.isBooked = false

            try context.save()
            print("Mock data saved successfully.")
        } catch {
            print("Error setting up mock data: \(error)")
        }
    }

    private func preloadParkingSpots(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<ParkingSpot> = ParkingSpot.fetchRequest()
        let count = (try? context.count(for: fetchRequest)) ?? 0

        if count == 0 {
            for i in 1...10 {
                let spot = ParkingSpot(context: context)
                spot.spotNumber = "Spot \(i)"
                spot.isBooked = false
            }
            try? context.save()
        }
    }

    func clearAllData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Listing.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try container.persistentStoreCoordinator.execute(deleteRequest, with: container.viewContext)
            print("All data cleared.")
        } catch {
            print("Failed to clear data: \(error)")
        }
    }
}
