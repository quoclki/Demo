//
//  HandleKeyboardProtocol.swift
//  Utilities
//
//  Created by Lu Kien Quoc on 3/12/19.
//  Copyright © 2019 NTT DATA. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol HandleKeyboardProtocol {
    @objc func handleKeyboard(willShow notify: NSNotification)
    @objc func handleKeyboard(willHide notify: NSNotification)
}

public extension HandleKeyboardProtocol where Self: UIViewController {
    func handleKeyboard(register: Bool) {
        if register {
            NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard(willShow:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard(willHide:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        } else {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }
    
}

/* HOW TO USE
 1. Implement HandleKeyboardProtocol to your VCtrl
 2. Register & Remove Observer Notifications
 3. Handle Keyboard Will Show & Keyboard Will Hide
 
 1/  class YourVCtrl: HandleKeyboardProtocol {
 override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
 2/          handleKeyboard(register: true)
 }
 
 override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
 2/          handleKeyboard(register: false)
 }
 
 3/      func handleKeyboard(willHide notify: NSNotification) {
    print("Keyboard Will hide")
 }
 
 3/      func handleKeyboard(willShow notify: NSNotification) {
    print("Keyboard Will show")
 }
 }
 
 */
