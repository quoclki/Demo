//
//  ArrayExt.swift
//  Utilities
//
//  Created by NTT DATA on 3/7/19.
//  Copyright © 2019 NTT DATA. All rights reserved.
//

import Foundation

public extension Array {
    /// group by key
    func groupBy<U : Hashable>(_ keyFunc: (Element) -> U) -> [U: [Element]] {
        var dict: [U:[Element]] = [:]
        for el in self {
            let key = keyFunc(el)
            dict[key] = (dict[key] ?? []) + [el]
        }
        return dict
    }
    
    /// append  multi element
    mutating func appends(_ elements: Element...) {
        for element in elements {
            append(element)
        }
    }

    mutating func appends(_ elements: [Element]) {
        for element in elements {
            append(element)
        }
    }

    /// remove object from array
    mutating func removeObject<U: Equatable>(_ object: U) -> Bool {
        for (idx, objectToCompare) in self.enumerated() {
            if let to = objectToCompare as? U {
                if object == to {
                    self.remove(at: idx)
                    return true
                }
            }
        }
        return false
    }
    
    /// subscript with index
    subscript (existAt index: Int) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

public extension Array where Element: NSAttributedString {
    func joinWithSeparator(_ separator: NSAttributedString) -> NSAttributedString {
        var isFirst = true
        return self.reduce(NSMutableAttributedString()) {
            (r, e) in
            if isFirst {
                isFirst = false
            } else {
                r.append(separator)
            }
            r.append(e)
            return r
        }
    }
    
    func joinWithSeparator(_ separator: String) -> NSAttributedString {
        return joinWithSeparator(NSAttributedString(string: separator))
    }
    
}

public extension CaseIterable where Self: Equatable {
    var index: Self.AllCases.Index? {
        return Self.allCases.firstIndex { self == $0 }
    }
}
