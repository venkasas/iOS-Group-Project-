//
//  Listing+CoreDataProperties.swift
//  Capstone_Project_A3
//
//  Created by Sasidurka on 2024-11-16.
//
//

import Foundation
import CoreData


extension Listing {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Listing> {
        return NSFetchRequest<Listing>(entityName: "Listing")
    }

    @NSManaged public var address: String?
    @NSManaged public var availability: String?
    @NSManaged public var listingDescription: String?
    @NSManaged public var location: String?
    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var isBooked: Bool
    @NSManaged public var bookedBy: String?
    @NSManaged public var bookingDate: Date?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var locationLatitude: Double
    @NSManaged public var locationLongitude: Double

}

extension Listing : Identifiable {

}
