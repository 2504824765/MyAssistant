//
//  TranslateVC-UIGestureRecognizerDelegate.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/22.
//

import Foundation
import UIKit

extension TranslateVC: UIGestureRecognizerDelegate {
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        translateTextField.resignFirstResponder()
    }
}
