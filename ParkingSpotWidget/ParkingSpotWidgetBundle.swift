//
//  ParkingSpotWidgetBundle.swift
//  ParkingSpotWidget
//
//  Created by Sasidurka on 2024-12-15.
//

import WidgetKit
import SwiftUI

@main
struct ParkingSpotWidgetBundle: WidgetBundle {
    var body: some Widget {
        ParkingSpotWidget()
        ParkingSpotWidgetControl()
        ParkingSpotWidgetLiveActivity()
    }
}
