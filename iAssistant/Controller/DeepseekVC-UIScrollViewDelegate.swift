//
//  DeepseekVC-UIScrollViewDelegate.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/18.
//

import Foundation
import UIKit

extension DeepseekVC: UIScrollViewDelegate {
    // UIScrollViewDelegate 方法：监听拖动事件
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 拖动时收起键盘
        queryTextView.resignFirstResponder()
        // 调用键盘收起的逻辑
        keyboardWillHide(Notification(name: UIResponder.keyboardWillHideNotification))
    }
}
