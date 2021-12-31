//
//  LocationData.swift
//  Todo
//
//  Created by Lu Kien Quoc on 26/12/2021.
//

import Foundation
import CoreLocation

class LocationData: NSObject {
    
    var latitude: Double? = nil
    var longitude: Double? = nil
    var airQuality: AqiData? = nil
    var locality: LocalityResponse? = nil
    
    init(_ coordinate: CLLocationCoordinate2D) {
        super.init()
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
    
    var locationNames: [String] {
        return locality?.localityInfo?.administrative?.sorted(by: { $0.order ?? 0 > $1.order ?? 0 }).prefix(2).map({ $0.name ?? "" }) ?? []
    }
}
