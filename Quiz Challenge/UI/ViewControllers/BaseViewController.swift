//
//  BaseViewController.swift
//  Quiz Challenge
//
//  Created by Pedro Almeida on 10/01/20.
//  Copyright © 2020 Pedro Almeida. All rights reserved.
//

import UIKit

protocol ViewProtocol: class {
    func showError(message: String)
}

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

extension BaseViewController: ViewProtocol {
    func showError(message: String) {
        DispatchQueue.main.async {
            self.showLoading(false, animated: false)
            let alert = UIAlertController(title: NSLocalizedString("error_alert_title", comment: ""), message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("error_alert_action", comment: ""), style: .default, handler: nil))

            self.present(alert, animated: true)
        }
    }
}
