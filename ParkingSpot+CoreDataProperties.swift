//
//  ParkingSpot+CoreDataProperties.swift
//  Capstone_Project_A3
//
//  Created by manpreet kaur on 2024-12-12.
//
//

import Foundation
import CoreData


extension ParkingSpot {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ParkingSpot> {
        return NSFetchRequest<ParkingSpot>(entityName: "ParkingSpot")
    }

    @NSManaged public var spotNumber: String?
    @NSManaged public var isBooked: Bool
    @NSManaged public var bookingDate: Date?
    @NSManaged public var bookedBy: String?

}

extension ParkingSpot : Identifiable {

}
