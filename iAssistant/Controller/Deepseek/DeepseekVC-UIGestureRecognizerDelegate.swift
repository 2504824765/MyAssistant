//
//  DeepseekVC-UIGestureRecognizerDelegate.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/22.
//

import Foundation
import UIKit

extension DeepseekVC: UIGestureRecognizerDelegate {
    // Tap to hide keyboard
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        queryTextView.resignFirstResponder()
        keyboardWillHide(Notification(name: UIResponder.keyboardWillHideNotification))
    }
}
