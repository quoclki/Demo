//
//  UIViewControllerExt.swift
//  MoffLogger
//
//  Created by Apple on 10/15/20.
//  Copyright © 2020 Moff, Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// Present View Controller with iPhone (Action sheet) and iPad (Popover)
    func presentViewController(_ alert: UIAlertController, sender: UIView, arrow: UIPopoverArrowDirection = .any) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert.modalPresentationStyle = .formSheet
            alert.view.clipsToBounds = true
            alert.preferredContentSize = alert.view.frame.size
            if let popover = alert.popoverPresentationController {
                popover.sourceView = sender
                popover.sourceRect = sender.bounds
                popover.permittedArrowDirections = arrow
            }
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    /// Show warning with text box
    @discardableResult
    func showWarningWithTextBox(_ title: String, message: String, txtPlaceholder: String = "", isSecure: Bool = false, keyboardType: UIKeyboardType = .default,
                                leftBtnTitle: String = "OK", leftAction: ((String) -> Void)?,
                                rightBtnTitle: String = "Cancel",  rightAction: (() -> ())? = nil) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField{txt in
            txt.placeholder = txtPlaceholder
            txt.addTarget(self, action: #selector(self.textInAlertChanged(_:)), for: .editingChanged)
            txt.isSecureTextEntry = isSecure
            txt.keyboardType = keyboardType
        }
        
        let left = UIAlertAction(title: leftBtnTitle, style: .default) { _ in
            if let txt = alert.textFields?.first {
                leftAction?(txt.text ?? "")
                return
            }
        }
        
        left.accessibilityHint = "1"
        left.isEnabled = false
        
        let right = UIAlertAction(title: rightBtnTitle, style: .cancel) { _ in
            rightAction?()
        }
        
        alert.addAction(left)
        alert.addAction(right)
        present(alert, animated: true, completion: nil)
        return alert
    }
    
    @objc func textInAlertChanged(_ sender: UITextField) {
        var responder: UIResponder? = sender
        
        while !(responder is UIAlertController) {
            responder = responder?.next
        }
        
        if let alert = responder as? UIAlertController {
            alert.actions.filter{$0.accessibilityHint == "1"}.first?.isEnabled = !(sender.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "").isEmpty
        }
    }
    
    /// Show alert with 1 button
    @discardableResult
    func showAlert(_ title: String, message: String,
                   buttonTitle: String = "OK", buttonAction: (() -> ())? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: buttonTitle, style: .default) { (action) in
            alert.dismiss(animated: true, completion: buttonAction)
        }
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        return alert
    }
    
    /// Show alert with 2 button
    @discardableResult
    func showAlert(_ title: String, message: String,
                   leftTitle: String = "OK", leftStyle: UIAlertAction.Style = .default, leftAction: (() -> ())? = nil,
                   rightTitle: String = "Cancel", rightStyle: UIAlertAction.Style = .default, rightAction: (() -> ())? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let left = UIAlertAction(title: leftTitle, style: leftStyle) { (action) in
            alert.dismiss(animated: true, completion: leftAction)
        }
        alert.addAction(left)
        let right = UIAlertAction(title: rightTitle, style: rightStyle) { (action) in
            alert.dismiss(animated: true, completion: rightAction)
        }
        alert.addAction(right)
        self.present(alert, animated: true, completion: nil)
        return alert
    }
    
    /// Show Popover ViewController
    func showPopover(_ popoverVCtrl: UIViewController, sender: UIView, arrow: UIPopoverArrowDirection) {
        if let presentedVCtrl = presentedViewController, type(of: presentedVCtrl) == type(of: popoverVCtrl) {
            return
        }
        
        popoverVCtrl.modalPresentationStyle = .popover
//        popoverVCtrl.preferredContentSize = popoverVCtrl.view.frame.size
        popoverVCtrl.view.clipsToBounds = true
        
        if let popover = popoverVCtrl.popoverPresentationController {
            popover.sourceView = sender
            popover.sourceRect = sender.bounds
            popover.permittedArrowDirections = arrow
        }
//        popover.delegate = self
        self.present(popoverVCtrl, animated: true, completion: nil)
        
    }

    /// Present Formsheet Page with Navigation ViewController
    func presentFormSheetNavigationContainer(_ parentVCtrl: UIViewController, mainVCtrl: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: mainVCtrl)
        nav.view.frame = mainVCtrl.view.bounds
        nav.setNavigationBarHidden(true, animated: false)
        nav.modalPresentationStyle = .formSheet
        nav.preferredContentSize = nav.view.frame.size
        parentVCtrl.present(nav, animated: true, completion: nil)
        return nav
    }

}
