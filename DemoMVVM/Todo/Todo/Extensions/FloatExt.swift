//
//  FloatExt.swift
//  MoffLogger
//
//  Created by Apple on 7/21/20.
//  Copyright © 2020 Moff, Inc. All rights reserved.
//

import Foundation

public extension Float {
    var radToDeg: Float {
        let value = 180 / Float.pi
        return self * value
    }
    
    var degToRad: Float {
        let value = 180 / Float.pi
        return self / value
    }
    
    /// return about the decimal string, that has a decimal length is location of the nearest decimal number is greater than 0 with long length is enter.
    /// Exp: 0.0000123456789 -> 0.0000123456
    ///     0.0123456 -> 0.0123456
    func specialString() -> String {
//        let length: Int = 6
//        let string = String(describing: self)
//        if let decimalString = String(describing: self).split(separator: ".")[safe: 1] {
//            let value = String(decimalString)
//            if let index = value.firstIndex(where: { $0 != "0" }) {
//                let distance = value.distance(from: value.startIndex, to: index)
//                return String(format: "%.\( distance + length )f", self)
//            }
//        }
        
        let regex = "(-?[0-9]+\\.0*[1-9]{1}([0-9]{0,4}[1-9]{1})?)"
        return String(describing: self).matches(for: regex).first ?? ""
    }
}
