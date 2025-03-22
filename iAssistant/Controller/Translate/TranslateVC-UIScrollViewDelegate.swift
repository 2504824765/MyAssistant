//
//  TranslateVC-UIScrollViewDelegate.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/22.
//

import Foundation
import UIKit

extension TranslateVC: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        translateTextField.resignFirstResponder()
    }
}
