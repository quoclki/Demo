//
//  CVImageBufferExt.swift
//  DetectingHumanBodyPosesDemo
//
//  Created by Apple on 12/03/2021.
//  Copyright © 2021 Moff, Inc. All rights reserved.
//

import Foundation
import AVFoundation
import VideoToolbox

extension CVImageBuffer {

    func getCGImage() -> CGImage? {
        var cgImage: CGImage?
        
        // Create a Core Graphics bitmap image from the pixel buffer.
        VTCreateCGImageFromCVPixelBuffer(self, options: nil, imageOut: &cgImage)
        // Release the image buffer.
        CVPixelBufferUnlockBaseAddress(self, .readOnly)

        return cgImage
    }
    
}
