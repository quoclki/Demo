//
//  UINavigationControllerExt.swift
//  MoffSDKExampleExt
//
//  Created by Apple on 4/14/20.
//  Copyright © 2020 Lu Kien Quoc. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    func getViewController<T: UIViewController>() -> T? {
        return self.viewControllers.first(where: { $0 is T }) as? T
    }
}

extension UINavigationItem {
    func clearBackButton() {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        leftBarButtonItem = backButton
    }
}
