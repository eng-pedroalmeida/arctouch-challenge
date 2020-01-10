//
//  LoadingAlertController.swift
//  Quiz Challenge
//
//  Created by Pedro Almeida on 10/01/20.
//  Copyright © 2020 Pedro Almeida. All rights reserved.
//

import UIKit

class LoadingAlertController: UIViewController {

    private let kCornerRadius: CGFloat = 16.0
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    private func setupView() {
        viewContainer.layer.cornerRadius = kCornerRadius
        activityIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
    }

    func show(by parentView: UIViewController, animated: Bool = true) {
        providesPresentationContextTransitionStyle = true
        definesPresentationContext = true
        modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        parentView.present(self, animated: animated)
    }
}
