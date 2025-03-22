//
//  DeepseekVC-UIScrollViewDelegate.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/18.
//

import Foundation
import UIKit

extension DeepseekVC: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        queryTextView.resignFirstResponder()
        keyboardWillHide(Notification(name: UIResponder.keyboardWillHideNotification))
    }
}
