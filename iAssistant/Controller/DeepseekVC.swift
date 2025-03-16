//
//  DeepseekVC.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/15.
//

import UIKit

class DeepseekVC: UIViewController, UITableViewDelegate {
    @IBOutlet weak var queryTextField: UITextView!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var queryTV: UITableView!
    
    var currentRowCount: Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.queryTextField.layer.cornerRadius = 10
        
        queryTV.delegate = self
        queryTV.dataSource = self
        
        // 监听键盘弹出通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        // 监听键盘收起通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        

    }
    
    deinit {
        // 移除通知监听
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        currentRowCount += 1
        queryTV.reloadData()
    }

    
    // 键盘弹出时调用
    @objc func keyboardWillShow(_ notification: Notification) {
        // 获取键盘的高度
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            
            // 更新文本框底部的约束
            bottomConstraint.constant = keyboardHeight - view.safeAreaInsets.bottom + 45
            
            // 获取键盘动画的持续时间
            if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
                UIView.animate(withDuration: duration) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    // 键盘收起时调用
    @objc func keyboardWillHide(_ notification: Notification) {
        // 恢复文本框底部的约束
        bottomConstraint.constant = 0

        // 获取键盘动画的持续时间
        if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
