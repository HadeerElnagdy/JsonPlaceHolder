//
//  ErrorAlertView.swift
//  JsonPlaceHolder
//
//  Created by Hadeer on 10.09.25.
//

import UIKit

final class ErrorAlertView {
    
    // MARK: - Static Methods
    static func showError(
        in viewController: UIViewController,
        title: String = Constants.AlertMessages.errorTitle,
        message: String,
        retryAction: (() -> Void)? = nil,
        cancelAction: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        if let retryAction = retryAction {
            alert.addAction(UIAlertAction(
                title: Constants.AlertMessages.retryAction,
                style: .default
            ) { _ in
                retryAction()
            })
        }
        
        alert.addAction(UIAlertAction(
            title: Constants.AlertMessages.cancelAction,
            style: .cancel
        ) { _ in
            cancelAction?()
        })
        
        viewController.present(alert, animated: true)
    }
    
    static func showError(
        in viewController: UIViewController,
        message: String,
        retryAction: (() -> Void)? = nil
    ) {
        showError(
            in: viewController,
            message: message,
            retryAction: retryAction,
            cancelAction: nil
        )
    }
    
    static func showError(
        in viewController: UIViewController,
        message: String
    ) {
        showError(
            in: viewController,
            message: message,
            retryAction: nil,
            cancelAction: nil
        )
    }
}
