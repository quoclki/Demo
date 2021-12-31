//
//  LocalityRequest.swift
//  Todo
//
//  Created by Lu Kien Quoc on 27/12/2021.
//

import Foundation

// MARK: - LocalityRequest
class LocalityRequest: Codable {
 
    var latitude: Double?
    var longitude: Double?
    var localityLanguage: String? = "en"
    
    init(_ latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }

}

// MARK: - LocalityResponse
class LocalityResponse: Codable {
    let latitude, longitude: Double
    let lookupSource, plusCode, localityLanguageRequested, continent: String?
    let continentCode, countryName, countryCode, principalSubdivision: String?
    let principalSubdivisionCode, city, locality, postcode: String?
    let localityInfo: LocalityInfo?
}

// MARK: - LocalityInfo
struct LocalityInfo: Codable {
    let administrative, informative: [Ative]?
}

// MARK: - Ative
struct Ative: Codable {
    let order: Int?
    let adminLevel: Int?
    let name, ativeDescription: String?
    let isoName, isoCode, wikidataID: String?
    let geonameID: Int?

    enum CodingKeys: String, CodingKey {
        case order, adminLevel, name
        case ativeDescription = "description"
        case isoName, isoCode
        case wikidataID = "wikidataId"
        case geonameID = "geonameId"
    }
}
