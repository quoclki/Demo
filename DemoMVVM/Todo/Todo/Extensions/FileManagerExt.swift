//
//  FileManagerEx.swift
//  Utilities
//
//  Created by NTT DATA VIETNAM on 8/27/19.
//  Copyright © 2019 nttdata. All rights reserved.
//

import Foundation

public extension FileManager {
    /// create folder in Document folder
    func createFolder(_ folder: String, isClear: Bool = false) -> URL? {
        guard let documentsURL = self.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let writePath = documentsURL.appendingPathComponent(folder)
        try? self.createDirectory(atPath: writePath.path, withIntermediateDirectories: true)
        if isClear {
            try? self.removeItem(at: writePath)
        }
        return writePath
    }
    
    /// get URLs link in Document folder
    func getURLsInDocument(_ folderName: String) -> [URL]? {
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return nil
        }
        
        let documentsURL = URL(fileURLWithPath: path).appendingPathComponent(folderName)
        return getUrlsInURL(documentsURL)
    }
    
    /// get URLs link in URL
    func getUrlsInURL(_ url: URL) -> [URL]? {
        if !self.fileExists(atPath: url.path) {
            return nil
        }

        do {
            let fileURLs = try self.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            return fileURLs
        } catch {
            print("Error while enumerating files \( url.path ): \( error.localizedDescription )")
        }
        
        return nil
    }
    
//    /// copy file from URL to URL
//    func copyFiles(from: URL, to: URL) {
//        do {
//            guard let fileList = self.getUrlsInURL(from), !fileList.isEmpty else {
//                return
//            }
//            for file in fileList {
//                let toDestination = to.appendingPathComponent(file.absoluteString.ns.lastPathComponent)
//                if self.fileExists(atPath: toDestination.path) {
//                    try self.removeItem(at: toDestination)
//                }
//                
//                try self.copyItem(at: file, to: toDestination)
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
//    }


}
