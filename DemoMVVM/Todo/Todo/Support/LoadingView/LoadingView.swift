//
//  LoadingView.swift
//  Todo
//
//  Created by Apple on 01/12/2021.
//

import Foundation
import UIKit

class LoadingView: UIView {
    
    // MARK: - Outlet
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var smallView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
 
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupOverlay()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupOverlay()
    }
    
    private func setupOverlay() {
        let nib = UINib(nibName: "LoadingView", bundle: .main)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        contentView.backgroundColor = UIColor(hexString: "000000", a: 0.1)
        smallView.backgroundColor = UIColor(hexString: "000000", a: 0.3)
        indicator.tintColor = .black
        addSubview(contentView)
        configUI()
        binding()
        handleAction()

    }
    
    // MARK: - Config UI
    private func configUI() {
        
    }
    
    // MARK: - Binding
    private func binding() {
        
    }
    
    // MARK: - Handle Action
    private func handleAction() {
        
    }
    
    func showLoadingView(_ isShow: Bool = true) {
        if isShow {
            self.superview?.bringSubviewToFront(self)
            indicator.startAnimating()
            return
        }
        
        self.superview?.sendSubviewToBack(self)
        indicator.stopAnimating()
    }

}
