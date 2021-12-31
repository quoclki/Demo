//
//  Base.swift
//  Todo
//
//  Created by Lu Kien Quoc on 25/12/2021.
//

import Foundation
import GoogleMaps

class Base {
    
    static var shared = Base()
    var AQI_TOKEN = "59eaf2754f6e4be8bba52fd54cb3229c1cf011bc"

    /// Init base
    /// Support for all neccessary frameworks to initialize
    func initBase() {
        GMSServices.provideAPIKey("AIzaSyAQGStoPYB4AfsvBiQ-Bnko9_QwJkIUjrc")
    }
    
}

enum AppError: Error {
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .unknown:
            return "unknow"
        }
    }
    
    var code: Int {
        switch self {
        case .unknown:
            return 1000
        }
    }
}
