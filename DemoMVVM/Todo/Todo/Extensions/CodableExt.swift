//
//  Encodable.swift
//  Utilities
//
//  Created by NTT DATA VIETNAM on 5/17/19.
//  Copyright © 2019 nttdata. All rights reserved.
//

import Foundation

public extension Data {
    /// to dictionary
    func toDictionary() -> [String: Any]? {
        return try? JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [String: Any] ?? [:]
    }

    /// to dictionary String
    func toDictionaryString() -> [String: String]? {
        return toDictionary() as? [String: String]
    }

    /// decode to another object with data
    func decode<T: Codable>(_ decoder: JSONDecoder = JSONDecoder()) -> T? {
        return try? decoder.decode(T.self, from: self)
    }
    
    /// to string
    func toString() -> String {
        return String(data: self, encoding: .utf8) ?? ""
    }
}

public extension Encodable {
    /// parse to data
    func toData(_ encoder: JSONEncoder = JSONEncoder()) -> Data? {
        return try? encoder.encode(self)
    }
    
    /// copy to another object
    func copyObject<T: Codable>(_ type: T.Type) -> T? {
        guard let encodeData = toData() else {
            return nil
        }
        
        return try? JSONDecoder().decode(type, from: encodeData)
    }
    
    /// to JSON string
    func toJSON() -> String? {
        guard let data = toData() else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
}


