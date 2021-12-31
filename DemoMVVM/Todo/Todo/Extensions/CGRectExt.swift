//
//  CGRectExt.swift
//  DetectingHumanBodyPosesDemo
//
//  Created by Apple on 04/03/2021.
//  Copyright © 2021 Moff, Inc. All rights reserved.
//

import Foundation
import UIKit

extension CGRect {
    
    /// Check line intersectsl line
    private func lineIntersectsLine(_ line1Start: CGPoint, _ line1End: CGPoint, _ line2Start: CGPoint, _ line2End: CGPoint) -> Bool {
        // Distance between the lines' starting rows times line2's horizontal length
        var q = (line1Start.y - line2Start.y) * (line2End.x - line2Start.x)
            //Distance between the lines' starting columns times line2's vertical length
            - (line1Start.x - line2Start.x) * (line2End.y - line2Start.y)
        let d =
        //Line 1's horizontal length times line 2's vertical length
        (line1End.x - line1Start.x) * (line2End.y - line2Start.y)
        //Line 1's vertical length times line 2's horizontal length
        - (line1End.y - line1Start.y) * (line2End.x - line2Start.x)

        if d == 0 {
            return false
        }

        let r = q / d

        q =
            //Distance between the lines' starting rows times line 1's horizontal length
            (line1Start.y - line2Start.y) * (line1End.x - line1Start.x)
            //Distance between the lines' starting columns times line 1's vertical length
            - (line1Start.x - line2Start.x) * (line1End.y - line1Start.y);

        let s = q / d
        if r < 0 || r > 1 || s < 0 || s > 1 {
            return false
        }

        return true
    }

    /// Check Intersecs line.
    func instersectsLine(start lineStart: CGPoint, end lineEnd: CGPoint) -> Bool {
        /*Test whether the line intersects any of:
         *- the bottom edge of the rectangle
         *- the right edge of the rectangle
         *- the top edge of the rectangle
         *- the left edge of the rectangle
         *- the interior of the rectangle (both points inside)
         */
        return (lineIntersectsLine(lineStart, lineEnd, CGPoint(x:self.origin.x, y: self.origin.y), CGPoint(x: self.origin.x + self.size.width, y: self.origin.y)) ||
            lineIntersectsLine(lineStart, lineEnd, CGPoint(x: self.origin.x + self.size.width, y: self.origin.y), CGPoint(x: self.origin.x + self.size.width, y: self.origin.y + self.size.height)) ||
            lineIntersectsLine(lineStart, lineEnd, CGPoint(x: self.origin.x + self.size.width, y: self.origin.y + self.size.height), CGPoint(x: self.origin.x, y: self.origin.y + self.size.height)) ||
            lineIntersectsLine(lineStart, lineEnd, CGPoint(x: self.origin.x, y: self.origin.y + self.size.height), CGPoint(x: self.origin.x, y: self.origin.y)) ||
            (contains(lineStart) && contains(lineEnd)))
    }
    
}

extension CGPoint {
    /// Check point is left or right of vector
    /// - parameters:
    ///     - self: the point to check
    ///     - a: start point of vector
    ///     - b: end point of vector
    func isLeftOfVector(_ a: CGPoint, b: CGPoint) -> Bool {
        return (b.x - a.x) * (y - a.y) - (b.y - a.y) * (x - a.x) > 0
    }

}
