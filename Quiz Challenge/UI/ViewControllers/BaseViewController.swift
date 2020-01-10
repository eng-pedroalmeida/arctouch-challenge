//
//  BaseViewController.swift
//  Quiz Challenge
//
//  Created by Pedro Almeida on 10/01/20.
//  Copyright © 2020 Pedro Almeida. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    private var loadingAlertView: LoadingAlertController?
    
    func showLoading(_ show: Bool, animated: Bool = true, onCompletion: (() -> Void)? = nil) {
        if show {
            if loadingAlertView == nil {
                loadingAlertView = LoadingAlertController()
            }
            
            loadingAlertView?.show(by: self, animated: animated)
        } else {
            loadingAlertView?.dismiss(animated: animated, completion: onCompletion)
        }
    }
}
