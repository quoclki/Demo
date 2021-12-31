//
//  StringExt.swift
//  MoffSDKExampleExt
//
//  Created by Apple on 4/14/20.
//  Copyright © 2020 Lu Kien Quoc. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var image: UIImage? {
        return UIImage(named: self, in: Bundle.main, compatibleWith: nil)
    }
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    var nsString: NSString {
        return self as NSString
    }
    
    func matches(for regex: String) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: regex) else {
            print("Invalid regex")
            return []
        }
        
        let results = regex.matches(in: self, range: NSRange(self.startIndex..., in: self ))
        return results.map { nsString.substring(with: $0.range)}
    }
    
    var isImageURL: Bool {
        do {
            let regexPng = try NSRegularExpression(pattern: "^*.png", options: .caseInsensitive)
            let regexJpg = try NSRegularExpression(pattern: "^*.jpg", options: .caseInsensitive)
            let regexJpeg = try NSRegularExpression(pattern: "^*.jpeg", options: .caseInsensitive)
            if regexPng.firstMatch(in: self, options: .reportProgress, range: NSMakeRange(0, self.count)) != nil
                || regexJpg.firstMatch(in: self, options: .reportProgress, range: NSMakeRange(0, self.count)) != nil
                || regexJpeg.firstMatch(in: self, options: .reportProgress, range: NSMakeRange(0, self.count)) != nil
            {
                return true
            }
            return false
        }
        catch let err {
            debugPrint(err)
            return false
        }
    }
    
    var iosDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: self) ?? Date()
    }
    
    var folding: String {
        return self.folding(options: .diacriticInsensitive, locale: .current)
    }
}
