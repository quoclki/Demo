//
//  ImageViewExt.swift
//  OTAFirmwareUpdate
//
//  Created by Apple on 5/8/20.
//  Copyright © 2020 Moff, Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    /// set tint color for UIImageView
    func setTintColor(_ tintColor: UIColor?) {
        guard let image = self.image?.withRenderingMode(.alwaysTemplate) else { return }
        self.image = image
        self.tintColor = tintColor ?? .clear
    }
}
