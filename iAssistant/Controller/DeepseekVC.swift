//
//  DeepseekVC.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/15.
//

import UIKit
import Alamofire
import SwiftyJSON
import Down

class DeepseekVC: UIViewController, UITableViewDelegate, UITextViewDelegate, UIScrollViewDelegate {
    @IBOutlet weak var queryTextView: UITextView!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var queryTV: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    
    var currentRowCount: Int = 1
    var query: String = ""
    var messages: [Message] = []
    var model: String = "deepseek-chat"
//    var responseFormat: ResponseFormat = ResponseFormat(type: "json_object")
    var responseFormat: ResponseFormat = ResponseFormat(type: "text")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.queryTextView.layer.cornerRadius = 10
        
        queryTV.delegate = self
        queryTV.dataSource = self
        queryTextView.delegate = self
        
        // 监听键盘弹出通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        // 监听键盘收起通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        messages.append(Message(content: "嗨！我是DeepSeek。我可以帮你搜索、答疑、写作，请把你的任务交给我吧～", role: "assistant"))
        
        let tapGasture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGasture)
    }
    
    deinit {
        // 移除通知监听
        NotificationCenter.default.removeObserver(self)
    }
    
    // Tap to hide keyboard
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        queryTextView.resignFirstResponder()
        keyboardWillHide(Notification(name: UIResponder.keyboardWillHideNotification))
    }
    
    // UIScrollViewDelegate 方法：监听拖动事件
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 拖动时收起键盘
        queryTextView.resignFirstResponder()
        // 调用键盘收起的逻辑
        keyboardWillHide(Notification(name: UIResponder.keyboardWillHideNotification))
    }
    
    // Press return to send
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            print("Return pressed")
            submitButtonPressed(self.submitButton)
            textView.resignFirstResponder() // 收起键盘
            textView.text = ""
            return false // 阻止回车键换行
        }
        return true
    }
    
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        if self.queryTextView.text.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            self.query = queryTextView.text
            currentRowCount += 1
            queryTV.reloadData()
            
            // Handle response
            print("Start sending request")
            messages.append(Message(content: self.queryTextView.text, role: "system"))
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer sk-5e9919b7e7e9498489c8e5a5ec3246d8", // 替换为你的 API 密钥
                "Content-Type": "application/json"
            ]
            
            let url = "https://api.deepseek.com/chat/completions"
            let parameters: [String: Any] = [
                "messages": messages.map { ["role": $0.role, "content": $0.content] },
                "model": model,
                "response_format": ["type": responseFormat.type]
            ]
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                if let data = response.value {
                    let responseJSON = JSON(data)
                    print(responseJSON)
                    let message = Message(content: responseJSON["choices"][0]["message"]["content"].stringValue, role: responseJSON["choices"][0]["message"]["role"].stringValue)
                    print("Message: \(message)")
                    self.messages.append(message)
                    self.currentRowCount += 1
                    self.queryTV.reloadData()
                }
            }
        }
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
        bottomConstraint.constant = 30

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
