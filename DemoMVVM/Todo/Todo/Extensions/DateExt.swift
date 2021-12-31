//
//  DateExt.swift
//  CoreMotionDemo
//
//  Created by Apple on 14/05/2021.
//

import Foundation

extension Date {
    
    func toString(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: self)
        
    }
    
}
