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

class DeepseekVC: UIViewController, UITableViewDelegate {
    @IBOutlet weak var queryTextField: UITextView!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var queryTV: UITableView!
    
    var currentRowCount: Int = 1
    var query: String = ""
    var messages: [Message] = []
    var model: String = "deepseek-chat"
//    var responseFormat: ResponseFormat = ResponseFormat(type: "json_object")
    var responseFormat: ResponseFormat = ResponseFormat(type: "text")
    
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
        
        messages.append(Message(content: "嗨！我是DeepSeek。我可以帮你搜索、答疑、写作，请把你的任务交给我吧～", role: "assistant"))
    }
    
    deinit {
        // 移除通知监听
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        if self.queryTextField.text.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            self.query = queryTextField.text
            currentRowCount += 1
            queryTV.reloadData()
            
            // Handle response
            print("Start sending request")
            messages.append(Message(content: self.queryTextField.text, role: "system"))
            
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
                    var message = Message(content: responseJSON["choices"][0]["message"]["content"].stringValue, role: responseJSON["choices"][0]["message"]["role"].stringValue)
                    print("Message: \(message)")
                    self.messages.append(message)
                    self.currentRowCount += 1
                    self.queryTV.reloadData()
                }
//                if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
//                    print("Raw Response: \(responseString)")
//                }
//                switch response.result {
//                case .success(let value):
//                    print("Response: \(value)")
//                case .failure(let error):
//                    print("Error: \(error.localizedDescription)")
//                }
            }
            print("request done")
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
