//
//  URLExt.swift
//  MoffAnalyzer
//
//  Created by Apple on 15/12/2020.
//  Copyright © 2020 Moff, Inc. All rights reserved.
//

import Foundation
import AVFoundation
import RxSwift

extension URL {
    
    // Merge video with 2 video
    func mergeVideo(_ url: URL, outputURL: URL, completed: @escaping ((URL?) -> ())) {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: self.path) || !fileManager.fileExists(atPath: url.path) {
            completed(nil)
            return
        }
        
        let listAsset = [AVAsset(url: self), AVAsset(url: url)]
        
        // 1
        let mixComposition = AVMutableComposition()
        let mainInstruction = AVMutableVideoCompositionInstruction()
        var duration = CMTime.zero
        var size: CGSize = CGSize.zero
        for (index, asset) in listAsset.enumerated() {
            // 2
            guard let track = mixComposition.addMutableTrack(withMediaType: .video, preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
                , let assetTrack = asset.tracks(withMediaType: .video).first else {
                    continue
            }
            
            // 3
            do {
                try track.insertTimeRange(CMTimeRangeMake(start: .zero, duration: asset.duration), of: assetTrack, at: index == 0 ? .zero : listAsset[safe: index - 1]?.duration ?? .zero )
                
            } catch {
                print("Failed to load first track")
                continue
            }
            
            // 4
            duration = CMTimeAdd(duration, asset.duration)
            
            // 5
            let instruction = AVMutableVideoCompositionLayerInstruction(
                assetTrack: track)
            if index == 0 {
                instruction.setOpacity(0.0, at: asset.duration)
                size = track.naturalSize
            }
            
            mainInstruction.layerInstructions.append(instruction)
            
        }
        
        if size == CGSize.zero {
            completed(nil)
            return
        }
        
        mainInstruction.timeRange = CMTimeRangeMake(start: .zero, duration: duration)
        
        // 6
        let mainComposition = AVMutableVideoComposition()
        mainComposition.instructions = [mainInstruction]
        mainComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        mainComposition.renderSize = CGSize(
            width: size.width,
            height: size.height)
        
        guard let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality) else {
            completed(nil)
            return
        }
        
        exporter.outputURL = outputURL
        exporter.outputFileType = .mp4
        exporter.shouldOptimizeForNetworkUse = true
        exporter.videoComposition = mainComposition
        exporter.exportAsynchronously {
            DispatchQueue.main.async {
                switch exporter.status {
                case .completed:
                    print("exported at: \(outputURL)")
                    completed(outputURL)
                case .failed, .cancelled:
                    print("\( String(describing: exporter.status) ): \(exporter.error.debugDescription)")
                    completed(nil)
                default: break
                    
                }
            }
        }
    }
    
    /// Crop video
    func cropVideo(_ startTime: Double, endTime: Double, outputURL: URL? = nil) -> Observable<URL> {
        let asset = AVAsset(url: self)
        let fileManager = FileManager.default
        let outputURL = outputURL ?? URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("temp.mov")
        if fileManager.fileExists(atPath: outputURL.path) {
            try? fileManager.removeItem(at: outputURL)
        }
        
        return Observable<URL>.create { (observer) -> Disposable in
            guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {
                return Disposables.create()
            }
            exportSession.outputURL = outputURL
            exportSession.outputFileType = .mov
            
            let timeRange = CMTimeRange(start: CMTime(seconds: startTime, preferredTimescale: 1000),
                                        end: CMTime(seconds: endTime, preferredTimescale: 1000))
            
            exportSession.timeRange = timeRange
            exportSession.exportAsynchronously {
                switch exportSession.status {
                case .completed:
                    print("exported at: \( outputURL )")
                    observer.onNext(outputURL)
                    observer.onCompleted()
                case .failed, .cancelled:
                    print("\( String(describing: exportSession.status) ): \(exportSession.error.debugDescription)")
                    if let error = exportSession.error {
                        observer.onError(error)
                    }
                    observer.onCompleted()
                default: break
                }
            }

            return Disposables.create()
        }
        
    }
        
}
