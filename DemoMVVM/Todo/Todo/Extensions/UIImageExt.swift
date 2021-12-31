//
//  UIImageExt.swift
//  MoffSDKExampleExt
//
//  Created by Apple on 4/15/20.
//  Copyright © 2020 Lu Kien Quoc. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension UIImage {
    /// Resize image
    func resize(newWidth w: CGFloat) -> UIImage? {
        if w >= size.width {
            return self
        }
        
        let scale = w/size.width
        let h = size.height * scale
        
        UIGraphicsBeginImageContext(CGSize(width: w, height: h))
        draw(in: CGRect(x: 0, y: 0, width: w, height: h))
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImg
    }
    
    /// Rotate image with radian
    func rotate(_ radians: CGFloat, flip: Bool = false) -> UIImage {
        var rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radians)).size
        rotatedSize.width = floor(rotatedSize.width)
        rotatedSize.height = floor(rotatedSize.height)
        UIGraphicsBeginImageContextWithOptions(rotatedSize, false, self.scale)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            
            // Now, draw the rotated/scaled image into the context
            if flip {
                context.scaleBy(x: 1, y: -1)
            }

            self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }

        return self
    }
    
    var cvPixelBuffer: CVPixelBuffer? {
        let image = self
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }

    /// Crop with CI Image
    static func cropImage(_ ciImage: CIImage, cropRect: CGRect) -> CGImage? {
        let ciCtx = CIContext()
        if let cgImage = ciCtx.createCGImage(ciImage, from: cropRect) {
            return cgImage
        }
        
        return nil
    }
    
    /// Get pixel color with Point
    func getPixelColor(pos: CGPoint) -> UIColor {
        guard let dataProvider = self.cgImage?.dataProvider else {
            return UIColor.clear
        }
                
        let pixelData = dataProvider.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }

}
