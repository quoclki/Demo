//
//  CustomTextField.swift
//  Utilities
//
//  Created by Lu Kien Quoc on 3/8/19.
//  Copyright © 2019 NTT DATA. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
open class CustomUITextField: UITextField {    
    @IBInspectable
    open var leftPadding: CGFloat = 0
    
    @IBInspectable
    open var placeHolderColor: UIColor? {
        didSet {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor ?? UIColor.clear])
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: leftPadding, dy: 0)
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: leftPadding, dy: 0)
    }
}

