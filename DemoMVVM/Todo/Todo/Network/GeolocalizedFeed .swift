//
//  GeolocalizedFeed .swift
//  Todo
//
//  Created by Lu Kien Quoc on 26/12/2021.
//

import Foundation
import CoreLocation

// MARK: - GeolocalizedFeedRequest
class GeolocalizedFeedRequest: Codable {
    var lat: Double?
    var lng: Double?
    var token: String?
    var optional: String?
    
    init(_ lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
    }

    init(_ coordinate: CLLocationCoordinate2D) {
        self.lat = coordinate.latitude
        self.lng = coordinate.longitude
    }

}

// MARK: - GeolocalizedFeedResponse
class GeolocalizedFeedResponse: Codable {
    let status: String?
    let data: AqiData?
    
}

// MARK: - DataClass
struct AqiData: Codable {
    let aqi, idx: Int?
    let attributions: [Attribution]?
    let city: City?
    let dominentpol: String?
    let iaqi: Iaqi?
    let time: Time?
    let forecast: Forecast?
    let debug: Debug?
}

// MARK: - Attribution
struct Attribution: Codable {
    let url: String?
    let name: String?
    let logo: String?
}

// MARK: - City
struct City: Codable {
    let geo: [Double]?
    let name: String?
    let url: String?
}

// MARK: - Debug
struct Debug: Codable {
    let sync: Date?
    
    private enum CodingKeys: String, CodingKey {
        case sync
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sync = try container.decode(String.self, forKey: .sync).iosDate
        
    }
    
}

// MARK: - Forecast
struct Forecast: Codable {
    let daily: Daily?
}

// MARK: - Daily
struct Daily: Codable {
    let o3, pm10, pm25, uvi: [O3]?
}

// MARK: - O3
struct O3: Codable {
    let avg: Int?
    let day: String?
    let max, min: Int?
}

// MARK: - Iaqi
struct Iaqi: Codable {
    let dew, h, p, pm25: Dew?
    let t, w: Dew?
}

// MARK: - Dew
struct Dew: Codable {
    let v: Double?
}

// MARK: - Time
struct Time: Codable {
    let s, tz: String?
    let v: Int?
    let iso: Date?
    
    private enum CodingKeys: String, CodingKey {
        case s, tz, v, iso
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        s = try container.decode(String.self, forKey: .s)
        tz = try container.decode(String.self, forKey: .tz)
        v = try container.decode(Int.self, forKey: .v)
        iso = try container.decode(String.self, forKey: .iso).iosDate
        
    }
}
