//
//  DistanceHelper.swift
//  eLegionTest
//
//  Created by Albert Garipov on 20.03.2023.
//

import Foundation
import MapKit

struct DistanceHelper {
    static func distanceFrom(location: CLLocation, userLocation: CLLocation) -> String {
        let distance = userLocation.distance(from: location)
        let distanceFormatter = MKDistanceFormatter()
        distanceFormatter.unitStyle = .default
        return distanceFormatter.string(fromDistance: distance)
    }
}
