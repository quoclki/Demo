//
//  CollectionExt.swift
//  MoffLogger
//
//  Created by Apple on 7/15/20.
//  Copyright © 2020 Moff, Inc. All rights reserved.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
