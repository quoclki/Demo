//
//  IntExt.swift
//  MoffLife
//
//  Created by Apple on 01/07/2021.
//  Copyright © 2021 Moff, Inc. All rights reserved.
//

import Foundation

extension Int {
    func toHoursMinutesSeconds () -> (hour: Int, minute: Int, second: Int) {
        return (self / 3600, (self % 3600) / 60, (self % 3600) % 60)
    }

}
