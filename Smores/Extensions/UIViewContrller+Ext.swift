//
//  UIViewContrller+Ext.swift
//  Smores
//
//  Created by Suha Baobaid on 3/7/22.
//

import Foundation
import UIKit



extension UIViewController {
    func presentMinimumAlertonMainThread(message: String, isError: Bool, dismissTime: TimeInterval) {
        DispatchQueue.main.async {
            let image = isError ? UIImage(systemName: "checkmark.circle.trianglebadge.exclamationmark") : UIImage(systemName: "checkmark.circle")
            let color = isError ? UIColor.orange: Colors.green
            let alertVC = MinimumAlertViewController(message: message, icon: image, color: color)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .coverVertical
            self.present(alertVC, animated: true, completion: { [weak self, weak alertVC] in
                let dismissGesture = CustomTapGesture(target: self, action: #selector(self?.shouldDismiss(_:)))
                
                dismissGesture.alertVC = alertVC
                alertVC?.view.window?.isUserInteractionEnabled = true
                alertVC?.view.window?.addGestureRecognizer(dismissGesture)
                Timer.scheduledTimer(withTimeInterval: dismissTime, repeats: false) { _ in
                    self?.dismiss(animated: true, completion: nil)
                    alertVC?.view.window?.removeGestureRecognizer(dismissGesture)
                }
            })
        }
    }
    
    @objc func shouldDismiss(_ sender: UIGestureRecognizer) {
        if let sender = sender as? CustomTapGesture {
            sender.alertVC?.view.window?.removeGestureRecognizer(sender)
        }
        self.dismiss(animated: true, completion: nil)
    }
}



