//
//  Loadings.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-27.
//

import Foundation
import RappleProgressHUD

protocol LoadingIndicatorDelegate {
    func startLoading()
    func startLoadingWithText(label: String)
    func stopLoading()
    func startLoadingWithProgress(current: CGFloat, total:CGFloat)
}

// -------- RappleProgressHUD -------- //

extension LoadingIndicatorDelegate {
    // Start loading
    func startLoading() {
        RappleActivityIndicatorView.startAnimating()
    }
    
    // Start loading with text
    func startLoadingWithText(label: String) {
        RappleActivityIndicatorView.startAnimatingWithLabel(label)
    }
    
    // Stop loading
    func stopLoading() {
        RappleActivityIndicatorView.stopAnimation()
    }
    
    func startLoadingWithProgress(current: CGFloat, total:CGFloat) {
        RappleActivityIndicatorView.setProgress(current/total)
    }
}
