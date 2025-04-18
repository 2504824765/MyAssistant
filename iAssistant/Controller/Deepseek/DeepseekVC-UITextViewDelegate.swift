//
//  DeepseekVC-UITextViewDelegate.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/18.
//

import Foundation
import UIKit

extension DeepseekVC: UITextViewDelegate {
    // Press return to send
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            submitButtonPressed(self.submitButton)
            textView.resignFirstResponder()
            textView.text = ""
            return false // 阻止回车键换行
        }
        return true
    }
}
